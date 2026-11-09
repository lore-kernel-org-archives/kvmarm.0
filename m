Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794210080;
	b=rRdlLTTIIRpAAXvzMpEFSAAwIyVfvUSO9MMvVeeuIUhhJXRzsZ6jnRws3IOBCR/lXx/i
	 rkfSjB6e0ySgtxoV6GevWO/j0aU1tE0k8Ld9HbVX4CNJHgYUs5J3c95l5BJaYInAzmtWM
	 V2uoQaXYJdh5E9RXC5rk/R/qDbJgAeYZM+2pZ8Ls8yq/rlXzvYFuzt6UVJQp4uKtkcIVu
	 kaHI1GVpBuIu4OC7iPdvw8mNB2DOqSbVRG66DjCFgoYCi3odmoxwihiWjO3mD4L5av+KX
	 +Kk0Vj+HZHz2T9OGGJrGMxmqCv/5eETOb8453OkV6XKBrVMUJihQ+0EZ1u2oE343wpg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794210080;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=3/KauWaXYG3OmrhCNO3AADgebVTxE9yJqLBY2sG9Sb0=;
	b=u9L/GceEWuK5wcLFlQFKU5yD/LrfRaA6CWvmbcmEH6THSJAK/wn9dG8Y4YVOLLC4XBnq
	 YRB32SFZxYUfB9JN8OxB3DnQzGqHP1Oms/qtJhDGjgvUWyogjmVzE+LwKiIBcM5LAXpE/
	 v0sfJupRapYLaHpBleI7UfXeUQMeO0+PWdBmztHuZqaZEdnxW/qYok5BQe/SIEyVUNsfc
	 3ySPyTGkLZ5ewmuZcgin/p5l2vGYLDD02i7vYPN3MQXOv6ixaCjyYu2wE6s0BpGwvvVc/
	 XhQhrGM74tdWohvWr5gRLzOTF3DW7GmlQbyNQ+RmbGyidRiJfsk8U6HU0is8oRQqEdw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HeEDTS3j;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.42
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1482A606A322
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 07:41:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1482A606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HeEDTS3j
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5c14bc5a743so2889e87.0
        for <kvmarm@lists.linux.dev>; Sun, 08 Nov 2026 23:41:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794210078; cv=none;
        d=google.com; s=arc-20260327;
        b=k+KHto7k0JPAuhxFNjNeu+SLiSlGlT9RLxNNIlucN2ABcQw3SNnAK5l7Bqq8gz6bxQ
         ORsgru8eqkQ9t1mBUI8Ur3RpjsRgTBQ/dgtKvTwKHRd+ATiawbHTS5WhZZhmw94DR+HR
         V7XEvLBZBwWLHFIgIhXT8Tu6FNGloioMeNvRI4jjENuSQTWhzdadJZCbuGloVUYpbCw3
         6zJQ/0q2gkDwn57MoWsE8uyA7jjLX8AvKhaECCTW17R7R2fmKE36yvnWdnqve6j27hTB
         qfep9R5bV717OKF4LPBQyoskeuKVuew0nhF31W1i5Cc2K29mX6DhLf55//BSIkaHDwoE
         jPRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=3/KauWaXYG3OmrhCNO3AADgebVTxE9yJqLBY2sG9Sb0=;
        fh=zm1fN8pvqazPGDLrc4obrXQY8yoMljJhuvEwliEymjg=;
        b=FwJLbnA62n8/iY6AXdgiOkBhEbOc3TcDAqgcpsatii2Q6DMiDVA4G7UxruTE15eQPS
         yL1PS9pkW/9zbOfagnb6K4pkJOT9SYQoILjOA6RlgZfG6M6L32JyrqETxAgfso4JoUJk
         i8TALd5+/Vw91fny383vWp+bv5AnN06JDWNzYLb4vA1Z9WVRoWkXG+ExnPU1usiPD4lC
         +gPLKm7bxlcWdL0I0iEIr59cfiBhVx7J4YnT0rzeKLTd6IPjd7Ryh0S7EEki6CEHFWZw
         a9TKC6SU3jjnLgmUGup1fjBTholiJXCx9pzX4kEOxwzaFLoQbA/hFV5jfckpZ96iD/MR
         YJnw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794210078; x=1794814878; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3/KauWaXYG3OmrhCNO3AADgebVTxE9yJqLBY2sG9Sb0=;
        b=HeEDTS3jKC0VEYSnams1BIV+UpZ/ty/+2FSDqf7rTCxMSqdqwygQr0SQfzQ/wkJ4jF
         y2x8OYuaSyNco4aiiuYtgB30jZQ05deATdmnT8Kv1yO53HoI05ry7r0rVspYtbNxFMcU
         AHUGY3a9R8CumfUlSrNG1xIGFtJUVyJZAftplNOmjbda4JXrwtkFt9UdjyUatb49hL1x
         0To7kP50yVNksae6nbgQnbT6amzdHEs5ch0R0MwXdTFWMpJoS6lqKJWrUkVeBdMyLqml
         qsKaD0fYs+ZH6xOfBF8paWH673R2QKcHFcvhgDOEY23oE2TUEJOPKTCe6RINIpvO5QdX
         u7qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794210078; x=1794814878;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=3/KauWaXYG3OmrhCNO3AADgebVTxE9yJqLBY2sG9Sb0=;
        b=thM1Xm4/v51A+tjs46ySzbtf10UFYK5L/fO1sih6/eY8Ksvp9+2N1lalDnYz6ghIWe
         uSFnWQM9NZfHGzxWsgAMgDj1tSxoq9gsOOU5ac7JavlvJC0FhtEbhoZ4n3vlKkbh3zeJ
         RfOT5Lj8xPNKz5WpF5UyUMvXNP34j+rw1tzUBYEN3nAyYCq6vjucX1QFx7nuqaapbYpT
         AKvFj76eVd1arUWSDlKoCagMwGI5CLkFertUlKg3BgT7f1KbDv8F4zmz8B8Br/jPrbCR
         VSOvKbJylz5RS1+yH1vgN6Oq0AbPbL0tETvKIctH2YHq8UZwj/ikNVo6r50XWaP1ngfU
         Ccrg==
X-Forwarded-Encrypted: i=1; AL+hErHLLT/Dhb/7SKbXx7F9vAPQTvophKLCaqJpefZIBNDvTQgmKRgRsn74bI5b+HjVaxvHUH79JDY=@lists.linux.dev
X-Gm-Message-State: APuU4Z9621km6VJO4WnCR8Qa/Y8WkxU++idIKBhuMplANVVmr9/CpkKw
	sQ7uQRlX9WiXruXcAOGtbnNCmYgPqmE1UHJ976qOxxSSuJlsooylhkLHBQTLST920WBhW2iIzqr
	HNjhxAYECN+ct8aMA3vK532smszG5SRwVcxM/HjxM
X-Gm-Gg: AYBFou2Qw8U8omGx5lW2ZDxzWWqg+wRIAp4RegrH0nGBZ4bquRp7K4s5i5a9TA+jBsQ
	b8QBmND0mBFpFzAKlPXZIjK7ZX4pgpNEWOlumAmuV2svp+NXc0ujorIQRamDsbrvI11P8gUFYBe
	SERf3Rvpbwl0TsLNYllhWk+jN2Bn4CBK7gHhA3Qfj1Fz8iVP+Lr/flJzPssF6OUxNfvHa0YWYBW
	p+EKodm1jucLSpgitbU19VwYuSRLvgglBDZ9OIRNelkNKv4Ig/C+xEnWWddO212qmKnj4zyl/9I
	gfFc+/ABOunFncKkClMKF0mWfomYW+dOTeaFikPBlAoqFbxFp/HiHjWQZk+iOuNgy40sGeyOuxu
	H1ZDwUZJIz1Yv29SBzmWHIFWblBrHJ6qrq56sG17pUHkCYGEnqbLEQt7rwbvpFXpKmQk4x8hbR9
	CBrXKeOTTF9GAd4rOQ0+VsNDkVPw==
X-Received: by 2002:ac2:4bcb:0:b0:5c1:53b5:2029 with SMTP id
 2adb3069b0e04-5c153b5217fmr3411e87.15.1794210077813; Sun, 08 Nov 2026
 23:41:17 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261102141304.126883-1-steven.price@arm.com> <20261102141304.126883-11-steven.price@arm.com>
 <fa0ee5a1-4c49-4c1f-bfbb-c270dc4b6301@arm.com>
In-Reply-To: <fa0ee5a1-4c49-4c1f-bfbb-c270dc4b6301@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 9 Nov 2026 07:40:41 +0000
X-Gm-Features: AclHuK87iuKTvXEWJaczVerdWgxPEZxpPBN7O-wc8AIa5Wl9vz0b6-1H_UF4Qbg
Message-ID: <CA+EHjTy970AWnhYoZ5OqxQ8ojCAELeejw60y2NmpDsM_ZMdu4Q@mail.gmail.com>
Subject: Re: [PATCH 10/11] KVM: arm64: CCA: Support runtime faulting of memory
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Suzuki, Steve,

On Thu, 05 Nov 2026 17:30:16 +0000, Suzuki K Poulose
<suzuki.poulose@arm.com> wrote:
[...]
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
[...]
> > @@ -1816,13 +1828,28 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
> >         /* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
> >         smp_rmb();
> >
> > +        if (kvm_vm_is_realm(kvm)) {
> > +                is_realm_private = kvm_realm_is_private_address(&kvm->arch.realm,
> > +                                                                s2fd->fault_ipa);
> > +
> > +                if (is_realm_private != kvm_gmem_is_private_gfn(kvm, canonical_gfn)) {
[...]
> I am wondering there is a way to make it a bit more generic. The issue
> is, only Realm has private memory with guest_memfd for now. Don't know
> the pKVM plans for it.

The plan is for protected pKVM VMs to be backed by guest_memfd too,
which would also hold each page's private/shared state [1]. So
kvm_arch_has_private_mem() will be true for them, and this comparison
applies as is. Only how the expected state is computed differs: for a
pVM it comes from the per-page share state rather than an IPA bit.

Steve, could you gate the guest_memfd checks on
kvm_arch_has_private_mem(kvm) rather than kvm_vm_is_realm(), this one
and the memslot check you proposed for 02/11? Only the
kvm_realm_is_private_address() and realm_map_ipa() calls are
realm-specific, and they could be VM_REALM cases of a switch on
vm_flavor, as Marc asked for on the v21 memslot check [2]. The macro
would then only widen to protected VMs when pKVM's guest_memfd support
lands.

Cheers,
/fuad

[1] https://lore.kernel.org/all/CA+EHjTz+WgXEW5RTxXf4oGeEb1Tsm5Ha4nOc4S1jBcp7jxP4+A@mail.gmail.com/
[2] https://lore.kernel.org/all/86mrsw2jrn.wl-maz@kernel.org/
