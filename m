Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A52476CDA
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 13:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664531; cv=none; b=LXy2eTCXhjjF485plcG3NhmqSx7R8v/czdb9GjB1dBMNXMGh7cH07msw/rlKhxndV79ugE5Bv5asTeMH+/KNoCNvfUhiMAaeBbaDMLOLyarq3oaFBwHavjMicVZwrPh+lbvb5EgbuK871g/oeI2tLo13uUMIubRg9/+pRPzyoaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664531; c=relaxed/simple;
	bh=gDmcKl40zrYBHhpGI7wl2By7zPK+qAR+/fB3o5jqPkY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=DSy2jCfnPofjpTd+MYzkKinKtDMGcjJRpbR3tkStYUSe9vkX7ka8CdwQpivYcOP2ZzMfAV1Hip0o/oZRfU8Qy2RAkPghnHxHkbxUm0aXnqej6I/gp8WTxt2F+DsiJAZ7aWTPx2XX8RuaH0xFEC1OQ4AZ5/wH1rBNaoybhTNyOMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P3ZyNTw3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P3ZyNTw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCF31F000E9;
	Tue, 25 Aug 2026 13:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787664522;
	bh=1TSR0s1wHZNE3+Ic3FeFngAmbTQVzx7yaIp2C4u0jWQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=P3ZyNTw3H3W515BogR9jOcksj2kkfQI0mUMT2R+G+n1ImdayXNXiX419jhmtXi750
	 O8922T8IGM7ruGrS+8h0kfRAVjGjtiUQLXWaoecdcYI4qUOb0pzMRTIXIxMik7l9Kb
	 qr1dsY84x3EF0K7wXWENLAxmoDAeH365czUnuff5n1ub3vRBiNZFBYVvSlwk6CR24v
	 2YpXfM/s6n9/Po9GYyKsjxzbpwT+8Vsl6cQoY7PPp28lLOXgoClAPX40foeG81TdbH
	 y/Rl9ATkDqHllrl77OEiLZHU+Kbn6IPCmNk407giAWqeCTW6XL3y0+4llR/sjbfQRC
	 tVEU/3eiF3YtQ==
X-Mailer: emacs 30.2 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	kernel-team@android.com, fuad.tabba@linux.dev,
	qperret@google.com
Subject: Re: [PATCH v4 06/17] KVM: arm64: Add pkvm_hyp_req infrastructure
In-Reply-To: <ao1OAx_zLwpaw_5Y@google.com>
References: <20260731143541.956291-1-vdonnefort@google.com>
 <20260731143541.956291-7-vdonnefort@google.com>
 <yq5afr02wstl.fsf@kernel.org> <ao1OAx_zLwpaw_5Y@google.com>
Date: Tue, 25 Aug 2026 18:58:31 +0530
Message-ID: <yq5a5x0yjpmo.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Vincent Donnefort <vdonnefort@google.com> writes:

> On Tue, Aug 25, 2026 at 01:11:10PM +0530, Aneesh Kumar K.V wrote:
>> Vincent Donnefort <vdonnefort@google.com> writes:
>> 
>> > Introduce a struct pkvm_hyp_req to enable the pKVM hypervisor to request
>> > resources from the host.
>> >
>> > Provide serialisation helpers to transport these requests via SMCCC
>> > registers (starting from a2):
>> >
>> >   pkvm_hyp_req_to_smccc() to encode into the SMCCC args.
>> >   smccc_to_pkvm_hyp_req() to decode them.
>> >
>> > When the hypervisor raises a request, the host must handle it and retry
>> > the HVC. To automate this sequence, introduce the pkvm_call_hyp_req()
>> > macro. This intercepts pending requests, invokes the handler and retries
>> > the HVC.
>> >
>> > Additionally, introduce a trace event to track the handling of these
>> > requests.
>> >
>> > Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
>> > Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
>> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
>> 
>> 
>> This is very similar to the memory-transferring SRO operations described
>> in section B4.3, RMI operations, of https://support.arm.com/documentation/den0137/2-0bet3/
>> 
>> The SRO model covers more details than the pkvm_hyp_req infrastructure.
>> Should we look at making the two more similar?
>> 
>> -aneesh
>
> Hum, this is really just a few lines of code. Also, pKVM doesn't need a stable
> ABI with the kernel. Implementing a portion of a spec here sounds way too
> complicated for that simple usage IMO. I struggle to see in what way this would
> make pKVM better.
>

My goal was mainly to see whether we could keep a similar design pattern
for the hypervisor requesting additional memory from the host. I wasn't
suggesting that CCA and pKVM should use the same helpers or code paths.

I was thinking this might be relatively easy to do on the pKVM side,
given that there is no strict ABI between the host and hypervisor. The
benefit would mostly be in keeping the design patterns similar: how an
incomplete hypercall is indicated, which registers are used for that,
and how additional memory is requested.

If aligning those patterns requires more work than the benefit it
provides, we can ignore this.

-aneesh

