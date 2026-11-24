Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795563022;
	b=zN1Mz1YRugk7kMcRrmt14w0MH05XU71UDkvWpsYTE7Al8kOpLWN/5ujkkZfh3xuXhg5/
	 aQW77fCDs1I19mPz0nB717b1LyBGWkNCv31muT2JkW0EqKP24k8Q5bYdruflBc1s9EbzU
	 05ozXhNSoOz8WOq2dcp+bcVMCeVcLkKcD/o1M7nRWpcZNlz6ImmeWYm9u3Q436QfSIH4t
	 TjyIGXIxk5O5sq68Aa7sMmkGdFgml/spAcZJyIz/i4uKvSvRQIFAE6olK9EI3w/dhjXVf
	 APWC4AjLOzNuHJ2I+BRhSyPF26cFid0ESQLf2jmfy4yTPozZ4njs/wT5r9Zb8qMgP8A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795563022;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:In-Reply-To:References:MIME-Version:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=tmoluJRxJ9HN+1c8Y5zGpOvMcLNPpYDSuvXeIRfQoGU=;
	b=JP/QcDNxh8hNC64/XG71cH88/vmesM6rONpD/75yfCER/3HUPYdcVxZpZ1K6Y25rxxnn
	 pKFHG70QF2DRTKajS48Obw6qCPyve6dlfxG2NpEsWUitVb5voxPCJ8ilJ5bzccDO1jk8E
	 8mI53m3WI2rpkWtvCYIVNsNwuh0nD+LJD59pakHfWnCNKg4mgsjykVpJYfzVY7CZi6AMH
	 D7XD+3/znX8dMmCrI4hu8U2/3cCbMZidCk9QN7qwkNryOqAGkFTXwAhTghSqLSoNhqxlg
	 0QgIOqxhHw08QeK8t9F1isjO8CF3jYAxu5cM4zzMgwVLFga3lckhJnk5sd11hdZE+CA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BGVTQYwM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.47
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DCC606A329
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 23:30:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44DCC606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BGVTQYwM
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-9212dac247aso53469796d6.1
        for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 15:30:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795563021; cv=none;
        d=google.com; s=arc-20260327;
        b=SKRM1YCKf23UAZ9DaVvvsfiumkqdXoPhCpgNxzn8rSYTrKvtDrv1m0OUhGF3Ojhosi
         eQvHdoeXVUmlrV4H7HmsQYCBuvM7UtnAoPc1aCzDsY8i336EMNipmX3fROpNuffRCpuF
         IFGVbCYPUREi16QLiiSl41ZR6CXPQJXHuofVCrDf1kJ3rj/8yfyLb8tOBhPl/VL8Y6wf
         OGRIfvxd/IcpA749cjI+3dUudR0fpoc1sL1TkNlRn/NubhPakH/orXG7ZkjMmpZ8y/Kj
         s7dCWrr0rvAr+qs8Po8m/V0oA8/YZiy8Cs36zVif8zZhkkURqv9Jonrb5daum9lGSIGW
         RFww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:dkim-signature;
        bh=tmoluJRxJ9HN+1c8Y5zGpOvMcLNPpYDSuvXeIRfQoGU=;
        fh=qMaYGtMmE4/CyY1sp3muIxelC81p9qCp36LMisaFRUI=;
        b=jJDr1fMovGOk9mry3zb3CJFsfiO66wHwg3fCgZpK2w2VUdSfYocKEW4/xyhi639alX
         C+XJIOoK+EvMh9g9yb023QG7dtrfa9FpabPMD3hTooMwNWyN9W0WN6vwWrQA6qsgJblX
         qvzo/KeUg1nnwn7AT1G12B/TGqJaDqjdsZNr1Uv1hbtN2FiL+azwBS+d/GWj6STN3ITi
         mwn8a80sJsXmhR74/gvB8n59S9JCpj2aKbN6EQ54xk1qIlQbNNKpGz2j1O7lm8hYmD6s
         ZUx2C7csoIRnKEBuxQbUOIZqjXEsjWI3Y3Cf7n323VUbiriE22SfMdMuMibOpoPL7XsD
         sPug==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795563021; x=1796167821; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:mime-version:references:in-reply-to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tmoluJRxJ9HN+1c8Y5zGpOvMcLNPpYDSuvXeIRfQoGU=;
        b=BGVTQYwMjSGbsaeH8oXvrneOEFc5q2NguhQrm7SzHggbHh5BmXZcQNjGw/PW+hs44K
         tf0IUOkVOJpe3gv7sXEtb+VR+GOpK17obd0w3pVUKm91fQOne67F6Cif2mv5vDOiG+9Q
         HMOPeHrk2YUUVES1jnsD6OcJwdVI00cnpDDTcLEJhQFhKjJNoKB1GUbmUDzFAvBmrKSs
         hqLif+LsjKG1ay//t6biQs3IVMx+vsCHmtEItRHdtNWgcKZ68XREdDUADL8uuN/oFnfE
         tH5lEM82AsqvqiqOTIYnOM/mJato7/d+h2CpDzuOCuyN6+vKl1Fq9xs54CG6/vkZhxxm
         S/Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795563021; x=1796167821;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:mime-version:references:in-reply-to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tmoluJRxJ9HN+1c8Y5zGpOvMcLNPpYDSuvXeIRfQoGU=;
        b=xk5Z7bYgzonXAhyqrxUq/D7D3qoVYcaeuZdaUoEDNm/hDRWEH451Z0zhSo8DvNHkYE
         iLfSih0hwvphMlHLMLnL2InxB8odrEb/vtC3Og8uzRVoF7Z35J7oJgV4HDYpk3T992Rb
         e9z6guTAxjtFPHJg2VrCx9Y9dFHUAepGlS2y2FI0Yejy4rxkVZsqi1bHlvcT3Nmb+WY2
         3k3rV++8Ojhf4Qap6BU/ZgewE7ZrWOEExt+GeAUcsr/g1VUD0oTzXGq740JxbEXULBhI
         Bcynt0u5FJ/WGjoqB36/hyvgus0duzCNjlDBqFNJqo511GqpKRDwRYAmatNO6lIheszu
         eZqw==
X-Forwarded-Encrypted: i=1; AL+hErFm0loyXcu5BT7PoTFFsguNzCJs7ieg1v314VWsvaNyfzSsxtyulS+tDddYi4Hh4TWxzzzrNxQ=@lists.linux.dev
X-Gm-Message-State: APuU4Z/3xzWlhec/AmFru/BwCJMA2fBiW/+BPOYD1XzRfS0UorsATOoW
	031HiH6N7MfEvvTEMt//QeY7Y7s3BDSPZO6/Bm0CEkriL/g6XBmhp4NtDrNmWXD18ENYiXdzOda
	k98ujUJvcFxZKaqiVA+dYHqMg1CKzLAmmJKqEB67i
X-Gm-Gg: AZFdTZcBu5ur8oky6qaP1hKk0qowK/mTUHtEurd3EreURJXf89+7i3NyZzteHkgOkap
	2aBoCL2YvdmGebsGDkA0cOgQKTisUbzE015P3YzMJKsyqVpM75s4Xd8pHE8I2QQoYdIunMWEHQx
	Fg3EQzhe9zyxFlvyRdNo3jMsILZlTzzePhRYnZPc0SbXIYYOoonkAEmmIV595pvdozcWrjSyWoL
	uELJfB3O59friwbv8mzyn7pllWmSlUVbiq67+J5Z7FZ8zKgqAw9VBoWpvvdSDSn9gpMTeR03+AU
	rEfqHFvX+CP7euKmqNoMEK0bL5+dHHP1MYj1jmcl86aywk5spfrEHsbn4v327opgwBoOp3GGDXZ
	oucKaP+GrdX6KoHcpthq0DlaBvq/KQx1xYuHFGZNkBbjAZEDIyZYJdGpIN65X81m8iaXL27vJDY
	fhSu+ZgicmjeX5HGRy2hRQgwc=
X-Received: by 2002:a0c:f412:0:b0:921:541:246b with SMTP id
 6a1803df08f44-92134a9123cmr301795036d6.38.1795563020302; Tue, 24 Nov 2026
 15:30:20 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 24 Nov 2026 15:30:19 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <sashiko-outbox-229096@kernel.org>
References: <20261123104233.95710-1-steven.price@arm.com> <20261123104233.95710-2-steven.price@arm.com>
 <sashiko-outbox-229096@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Date: Tue, 24 Nov 2026 15:30:19 -0800
X-Gm-Features: Aa3M54o433xbzGFqcKUYR3R8okBny6foO_6QsBRN_-OVy4JGrTMEGT43jesbap4
Message-ID: <CAEvNRgGU+z609edF+Mw8xQ0NDUDKn9jjxJjJWTyUqJ0N2BGEHQ@mail.gmail.com>
Subject: Re: [PATCH v4 01/11] KVM: arm64: guest_memfd: Check mmap support when
 preparing memslot
To: sashiko-reviews@lists.linux.dev, Steven Price <steven.price@arm.com>, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] KVM: arm64: kvm_arch_prepare_memory_region() rejects non-mmap
>   guest_memfd
> --
>
> commit a0665f8dc612d05686ef019cc8462841573fe88c
> Author: Steven Price <steven.price@arm.com>
>
> KVM: arm64: guest_memfd: Check mmap support when preparing memslot
>
> This commit introduces kvm_gmem_slot_supports_mmap() and uses it in
> kvm_arch_prepare_memory_region() to require that all guest_memfd-backed
> memslots on arm64 come from files created with GUEST_MEMFD_FLAG_MMAP.
>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 1db10d8d6db73..2825fccd2a197 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -2839,10 +2839,10 @@ int kvm_arch_prepare_memory_region(struct kvm *k=
vm,
>>  		return -EFAULT;
>>
>>  	/*
>> -	 * Only support guest_memfd backed memslots with mappable memory, sinc=
e
>> -	 * there aren't any CoCo VMs that support only private memory on arm64=
.
>> +	 * All VMs need mappable guest_memfd memory, as the memslot's HVA may =
be
>> +	 * used to access shared memory even if guest faults use guest_memfd.
>>  	 */
>> -	if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
>> +	if (kvm_slot_has_gmem(new) && !kvm_gmem_slot_supports_mmap(new))
>>  		return -EINVAL;
>>
>>  	/* guest_memfd is incompatible with MTE. */
>
> [Severity: Medium]
> As reported by Suzuki K Poulose on v2 [1], should
> kvm_arch_prepare_memory_region() drop this guest_memfd check altogether
> rather than rejecting memslots backed by a guest_memfd created without
> GUEST_MEMFD_FLAG_MMAP?
>
> Both gmem_abort() and realm_gmem_abort() fault in guest_memfd pages via
> kvm_gmem_get_pfn() without using new->userspace_addr, and
> kvm_arch_prepare_memory_region() does not verify that new->userspace_addr
> maps the guest_memfd or any valid VMA.  Requiring GUEST_MEMFD_FLAG_MMAP
> here fails KVM_SET_USER_MEMORY_REGION2 with -EINVAL for VMs (such as
> Realms) that bind private-only guest_memfd instances without allowing hos=
t
> userspace mmap, and on v3 the guest_memfd maintainer noted that this chec=
k
> is unnecessary and should be removed rather than exposing
> kvm_gmem_slot_supports_mmap().
>

I agree with Sashiko here. I traced the history of this check:

    if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
        return -EINVAL;

In [1], Arm64 guest_memfd enablement, !kvm_memslot_is_gmem_only(new)
meant "this guest_memfd does not support mmap()". Arm64 had no CoCo
private-memory VMs yet, so guest_memfd was only usable for shared memory
where the host VMM needed mmap() to access guest RAM. Rejecting
non-mappable guest_memfd slots prevented unusable private-only memslots.

In [2], pKVM support was added. The v1 of [2], [3], says pKVM uses
anonymous memory. pKVM doesn't really specifically use gmem, so there's
actually no change, this check doesn't really affect pKVM.

Conversions [4] made stage 2 faults (mostly on x86), always get memory
from gmem. On arm, as long as it is a gmem memslot, it already always
got memory from gmem.

Now that ARM CCA supports private memory, we should drop this check
completely, I think David noted that right when it was added [5], and
that's what Sean means too [6].

If userspace sets up gmem with a memslot and doesn't set up mmap,
userspace probably won't be able to set up a running ARM CCA VM, but
that's userspace's bug imo.

Imo even back in [1] perhaps the check didn't need to be added, it's
just a userspace bug to try and set up a memslot with gmem that can't
really be used.

[1] https://lore.kernel.org/all/20250729225455.670324-21-seanjc@google.com/
[2] https://lore.kernel.org/all/20260330144841.26181-1-will@kernel.org/
[3] https://lore.kernel.org/all/20260105154939.11041-1-will@kernel.org/
[4] https://lore.kernel.org/all/20260910-gmem-inplace-conversion-v13-12-dd6=
fbf94f4e1@google.com/
[5] https://lore.kernel.org/all/2195c01b-3a17-46c5-a013-66922e8509bd@redhat=
.com/
[6] https://lore.kernel.org/all/av8No1rvJLXwciId@seanjc-mac.roam.internal/

> [1] https://lore.kernel.org/r/26a29420-8d27-4069-bbd5-28692c9e8542@arm.co=
m
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123104233.95=
710-1-steven.price@arm.com?part=3D1
