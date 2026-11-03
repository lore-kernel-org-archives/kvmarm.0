Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.240
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793709766;
	b=gbSGJk29uXZUHFc2iThjc+7IjHb6BMK76i5tOE5TiJFBLVwcV4l6Wg3gyNLd3cZ6zfSm
	 3Ote6o1TYwnfgWBT5+C3QyEqe7JZ7wN25J5HfNvRT81jl5+48/+ysgPcn6/Fzuso8qBaI
	 W7Rpqyy02GTZ4Z90MlXaQ71vekgBS2Uig6zEj2MDS7+OzUEOJkhVgwfpALdAZtX/FBUv6
	 7bnaU6LDPQHB9vxWTK7++lCt2d8qJe31z74YT0sMz3qPO5MSy4PwCARg4I4UaJAoe7U9m
	 PK9Q55nTdI2FsmLXYTfPeBxlEdAssBEBxPrQLblWFdQ8WCew2E4NtOl/c37/sAEubZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793709766;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=sCjolPt5zocwoOY1DIpOdaSXAojR7+UgtysjrvaooX8=;
	b=u5TQUmLlV60DKRyKK0PlPHN3U1WN2veEDj1cgaQElxBAGi/h6HS2w0gjkCpMNObq2u/x
	 LQrG3C9jQcYereE02H0c4qF8qJixeWGlClraqfkq7EH+Nj728s+1iwt+F7RtDzJIq3bJS
	 P6W0nlvwh0hr9uvYsQydDDbUB+l9qtPJHtIpFJ+wrMmJMeDangQMDM6u8TGuZOBZXinjv
	 YcBGlamfhrT3sbt+dDmnK2cXjbmR7M5QJ8NPbhkd8lYhqeIOxkG+dIyqqsFDluBsRmjBr
	 5GcBr43M6DHHWT7DV8M9EwVeF9Uh/YMhPZLBmhL9zPLniZk4sknasuvJOucSl36546Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="hVcmXel/";
	arc=none smtp.remote-ip=91.218.175.240
Received: from mta0.migadu.com (out-240.mta0.migadu.com [91.218.175.240])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEABD606A328
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 12:42:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DEABD606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hVcmXel/
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=sCjolPt5zocwoOY1DIpOdaSXAojR7+UgtysjrvaooX8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793709762; v=1; x=1794314562;
 b=hVcmXel/HDoDFM+b1poMqU9g5bDjZsPCVz4qvjd8tLp6G7tclXR1cE2oMhQEBs5bJjGGGQFP
 TCyZwC/6ufWxttcgt4IqDEbGB9Ss7PC0xxf9oCwj4NaLkNZ2dXPjRGjHWw7Dlo5HGWo2xb3P7ya
 XqzMlbB3YMo9EazoMpFxHdhY=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 585fc12482fdff96;
	Tue, 03 Nov 2026 12:42:42 +0000
X-Mizu-Trace-ID: 585fc12482fdff96
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: sashiko-bot@kernel.org
Cc: kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v2] KVM: arm64: nv: Size nested stage-2 MMUs by the NV PARange cap
Date: Tue,  3 Nov 2026 12:42:42 +0000
Message-ID: <20261103124242.2177173-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-195084@kernel.org>
References: <20261103102436.1605347-1-fuad.tabba@linux.dev> <sashiko-outbox-195084@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 03 Nov 2026 10:55:42 +0000, sashiko-bot@kernel.org wrote:
[...]
> TGRAN4/TGRAN16 at 52_BIT and TCR_EL1/TCR_EL2 unsanitised) only against
> TCR_EL1.{DS,IPS} and the physical CPU's 52-bit PARange rather than bounding
> it by VTCR_EL2?

Yes, but only for a guest that sets {I}PS beyond the 48-bit PARange
it's given, and this patch doesn't change the fast path.

[...]
> When __kvm_find_s1_desc_level() returns an error, inject_abt64() returns
> early without pending an exception or updating FAR_ELx/ESR_ELx.
> kvm_inject_size_fault() then unconditionally clears bits [5:0] of the guest's
> existing exception_esr_elx(vcpu), and kvm_handle_guest_abort() returns 1,
> re-entering the guest at the same instruction in an infinite loop.

Pre-existing: kvm_inject_size_fault() and the out-of-IPA-range SEA pass
the IPA as the abort address, which the S1PTW re-walk has taken as the
VA since 50f77dc87f133 ("KVM: arm64: Populate level on S1PTW SEA
injection"). With this patch, an NV guest's table walk above 2^48
reaches it too.

I'll fix it in v3, with two patches added before this one: build the
address size fault without the re-walk, which can't reach a table above
the limit, and pass FAR_EL2 at both sites.

> Also, when S1PTW == 0 with stage-1 translation enabled (a stage-1 leaf
> descriptor outputs an OA in [2^48, 2^52)), doesn't kvm_inject_size_fault()
> write the reconstructed fault IPA into exception_far_elx(vcpu) instead of
> kvm_vcpu_get_hfar(vcpu) and report level 0 instead of the leaf level?

Yes for the FAR, same fix. Level 0 is deliberate, from 85ea6b1ec915c
("KVM: arm64: Inject exception on out-of-IPA-range translation fault"),
and it will be there in v3.

[...]
> Once valid stage-2 PTEs are installed above 48 bits in kvm->arch.mmu.pgt,
> wouldn't L1 accesses to those GPAs succeed directly in hardware (or take
> stage-2 permission or access flag faults that bypass the
> esr_fsc_is_translation_fault(esr) check in kvm_handle_guest_abort()) instead
> of getting an address size fault?

Only for memory userspace placed beyond the advertised 48-bit PARange,
where the guest gets what it had before this patch.

Cheers,
/fuad
