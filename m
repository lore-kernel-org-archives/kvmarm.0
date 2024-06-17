Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4701198851
	for <kvmarm@lists.linux.dev>; Mon, 17 Jun 2024 13:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718631648; cv=none; b=IQbGhATF6DcrWe87fyVCH7LWWTBQs3NC7t01fl+zM7qmReb3bXH8dfDtASsnu19Ixu91Cs5JkSpk8gkkpoBPsBsbS9NZTa1jiG31dWbTtvBvELHPD+EUECJzPePDBglQUDfFtiyP67ue1fI5Wa4lDnQYf3UqspeIsgDVdbZQ4pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718631648; c=relaxed/simple;
	bh=bawAaxUsVQjPIttaLxacGUkQ6D3c/vPkGfmc2XFJ9R8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=RHJwrYaNwQ2/9uv3hlY0jwepxOjxw9Lb9WdTwAMwOY4DJx2yNoZEmPxP/F5FCMLll2ky8rMkIMUFCcfeS/YVqHuIarAej7pm1KOC9JLMm8kMfguL3Cp7Do6HF7M2Jo0EL+LzKeQWgQSwZve5RYoYoKD5Z49CCnTZs2MzsZSGv4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EA1krSzb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EA1krSzb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718631645;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3ZBlbppOoi/sPSeYF7gaxdAuqfyJGO0cqsg4bud1ypk=;
	b=EA1krSzbUnOhi20xJaf9CmZ683ylkbydp2Nqe4tvthiNYBOtCzczoC1ZNry0L6hKVMTbp2
	2bBWtkrLogacimyl6qxmLzu+tDoQdUm079vSBBjUmdNMxfpYa6byzdGzqKUgGwERe5+G+4
	xJ2eo5SqrBXDgfS37BQIzlF6LSA/eJ8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-449-htwtfZpzNTiLJPIb1IiYrA-1; Mon,
 17 Jun 2024 09:40:42 -0400
X-MC-Unique: htwtfZpzNTiLJPIb1IiYrA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E0D2A19560AE;
	Mon, 17 Jun 2024 13:40:37 +0000 (UTC)
Received: from oldenburg.str.redhat.com (unknown [10.39.192.203])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 744B819560AE;
	Mon, 17 Jun 2024 13:40:29 +0000 (UTC)
From: Florian Weimer <fweimer@redhat.com>
To: Szabolcs Nagy <szabolcs.nagy@arm.com>
Cc: Joey Gouly <joey.gouly@arm.com>,  dave.hansen@linux.intel.com,
  linux-arm-kernel@lists.infradead.org,  akpm@linux-foundation.org,
  aneesh.kumar@kernel.org,  aneesh.kumar@linux.ibm.com,  bp@alien8.de,
  broonie@kernel.org,  catalin.marinas@arm.com,
  christophe.leroy@csgroup.eu,  hpa@zytor.com,
  linux-fsdevel@vger.kernel.org,  linux-mm@kvack.org,
  linuxppc-dev@lists.ozlabs.org,  maz@kernel.org,  mingo@redhat.com,
  mpe@ellerman.id.au,  naveen.n.rao@linux.ibm.com,  npiggin@gmail.com,
  oliver.upton@linux.dev,  shuah@kernel.org,  tglx@linutronix.de,
  will@kernel.org,  x86@kernel.org,  kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 17/29] arm64: implement PKEYS support
In-Reply-To: <Zln6ckvyktar8r0n@arm.com> (Szabolcs Nagy's message of "Fri, 31
	May 2024 17:27:30 +0100")
References: <20240503130147.1154804-1-joey.gouly@arm.com>
	<20240503130147.1154804-18-joey.gouly@arm.com>
	<ZlnlQ/avUAuSum5R@arm.com>
	<20240531152138.GA1805682@e124191.cambridge.arm.com>
	<Zln6ckvyktar8r0n@arm.com>
Date: Mon, 17 Jun 2024 15:40:27 +0200
Message-ID: <87a5jj4rhw.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

* Szabolcs Nagy:

>> A user can still set it by interacting with the register directly, but I guess
>> we want something for the glibc interface..
>> 
>> Dave, any thoughts here?
>
> adding Florian too, since i found an old thread of his that tried
> to add separate PKEY_DISABLE_READ and PKEY_DISABLE_EXECUTE, but
> it did not seem to end up upstream. (this makes more sense to me
> as libc api than the weird disable access semantics)

I still think it makes sense to have a full complenent of PKEY_* flags
complementing the PROT_* flags, in a somewhat abstract fashion for
pkey_alloc only.  The internal protection mask register encoding will
differ from architecture to architecture, but the abstract glibc
functions pkey_set and pkey_get could use them (if we are a bit
careful).

Thanks,
Florian

