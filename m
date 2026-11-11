Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.113
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794415573;
	b=U3LXAzqA9JAFr0xquuFR17nxPRLlFmGihZF5yiaTbx6DJ89t1WDRFy8e4DFx6x9S6LeJ
	 hFp9hZYx8dp6YVVolKlMTVoBSOIg5mKItpLZuSgJJ1Um5/+cq4ON7lpbIfgqANQBzhH3O
	 +2d+fLFKpnl0RTZ6iPib+l/VmJF/XfkcGHk4MCSV5hdoTkwebnBgBsDmKPaAQwPtql7ix
	 AHPZiThcJ4HC/9+/BxbHFzXtySjIc2rkEVfXJq7qBuKgrBlvZec7w5WeOuN5E+0enXJHO
	 YXksZhp3XUXqRZqcg6gB5B0lb6S8QC8yJHRTBH2Cw87FVYAHg4PzkjkrIXwrh4g5xgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794415573;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=zfYkUkK1FvEiamJkD2w+G92+ZaU+ueOZOEIhISapy8E=;
	b=CItBGNDZRQUhdnnCenf0zXZb67GnEgbHSJhQu4erWWFRAU4dHSt3JVrGMyq7YnMWNfa0
	 x3eopr+6qDpQKVsr1IYJvZXAtbNVBXv+74rpUYJmAiLZMhrm2K4iRbUH222I0+73aox8l
	 e5WOicfb7JPSPoGMt9j2AOIEnLOxik86EchE8kD8/WQr7J6oAYtkC6R2XW8d4Ulevo2F5
	 4ck5oh+4S8URFfxQ5KrWLmYJ3y613u70irYhlqgRARqXJlTp8Ubh11kypadcqa5ZIl51F
	 IH/RY7TwF6BCQVtvfJGPhZbiHaDds3VvMEqrMt8/6XrXRQidlmQucdmt3UEt8uTQ/mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=dtbNmzkB;
	arc=none smtp.remote-ip=91.218.175.113
Received: from mta0.migadu.com (unknown [91.218.175.113])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2435C606A321
	for <kvmarm@lists.linux.dev>; Wed, 11 Nov 2026 16:46:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2435C606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=dtbNmzkB
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=vTOKXuEi2SgorO3quCcM6rXO+IcsXT+k+wyiUNo4CmU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794415568; v=1; x=1795020368;
 b=dtbNmzkBU+l0UXQUiLmSRtxdPEKWkxw+iOV6DZ9NaJJNCL4EuukzlLvlAhvZq9MwKQ5d32G+
 SXTeqSubKp1ijl/yOc7nydlVCqEkX3fTNHHMLa+X4b55ZIsBgmtlo8o5pP2DR6c0bTQQODyeqBK
 g0mUa+sl2zYKlg7QnI+LsrZs=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 542fbedc8ff8cfdd;
	Wed, 11 Nov 2026 16:46:08 +0000
X-Mizu-Trace-ID: 542fbedc8ff8cfdd
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5c00d7ac49dso5629e87.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Nov 2026 08:46:04 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEcIhJb0Jg1gOW37X2yNlYdkj3j2V90LGZXGMw6rIHHBLv4Un9XzuWZPnNn+1pgzFVUSN8BDko=@lists.linux.dev
X-Gm-Message-State: APuU4Z87OnJzrdMcw3QySqyS1rNZmfx06LUE8eo51veAgyGcQE7nSbDq
	y55kIXpLu54Kbj52b7miKDYjoMrqJffBVuOv5Byy6+rd06mObXwIfLbqdnTPJjxNj6r1vB+kAOU
	NE5HlasxdbNBi/KggFJWxC4P1VJ9nmR4G0oe+gLRv
X-Received: by 2002:a05:6512:1281:b0:5c1:488e:a067 with SMTP id
 2adb3069b0e04-5c15e321265mr149685e87.16.1794415563460; Wed, 11 Nov 2026
 08:46:03 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261001135711.1640520-1-fuad.tabba@linux.dev>
 <20261001135711.1640520-10-fuad.tabba@linux.dev> <5fa8a1fb-4e2c-4746-8a70-a47f387ef0d6@arm.com>
In-Reply-To: <5fa8a1fb-4e2c-4746-8a70-a47f387ef0d6@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 11 Nov 2026 16:45:27 +0000
X-Gmail-Original-Message-ID: <CA+EHjTyCcGPMte9=HuqyvCS7CCCt80Lc_JQuA+1e3ZE+3A0zqQ@mail.gmail.com>
X-Gm-Features: AclHuK_8e85qNvEPUChw2hXq-xwQhB1Rl-UgkdF_cZM8i8KqhVquzOK3Y1yl4BA
Message-ID: <CA+EHjTyCcGPMte9=HuqyvCS7CCCt80Lc_JQuA+1e3ZE+3A0zqQ@mail.gmail.com>
Subject: Re: [PATCH v4 09/18] KVM: arm64: Implement HVC handling for protected
 guests at EL2
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, steven.price@arm.com, vdonnefort@google.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Ryan,

On Wed, 11 Nov 2026 13:59:17 +0000, Ryan Roberts <ryan.roberts@arm.com> wrote:
[...]
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
[...]
> > @@ -2622,6 +2622,10 @@ static void kvm_hyp_init_symbols(void)
> >          kvm_nvhe_sym(__icache_flags) = __icache_flags;
> >          kvm_nvhe_sym(kvm_arm_vmid_bits) = kvm_arm_vmid_bits;
> >
> > +        kvm_nvhe_sym(spectre_v2_state) = arm64_get_spectre_v2_state();
> > +        kvm_nvhe_sym(spectre_v4_state) = arm64_get_spectre_v4_state();
> > +        kvm_nvhe_sym(spectre_bhb_state) = arm64_get_spectre_bhb_state();
>
> Is it really correct to snapshot this state then use it at runtime assuming its
> still accurate? See below...

These can't change after this point: update_mitigation_state() doesn't
update a state once system_capabilities_finalized() is true, and
kvm_arm_init() runs after that.

[...]
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
[...]
> > @@ -1181,8 +1187,70 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
[...]
> > +        case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
> > +                /* The workaround calls themselves are handled on hyp entry. */
> > +                val[0] = SMCCC_RET_NOT_SUPPORTED;
[...]
> > +                case ARM_SMCCC_ARCH_WORKAROUND_2:
> > +                        switch (spectre_v4_state) {
> > +                        case SPECTRE_VULNERABLE:
> > +                                break;
> > +                        case SPECTRE_MITIGATED:
> > +                                /* With SSBS advertised the guest's default is safe. */
> > +                                if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, SSBS, IMP))
> > +                                        break;
>
> For this case (and the break immediately above) you return val[0] =
> SMCCC_RET_INVALID_PARAMETER (from init at top of this function). But the
> kernel's kvm_smccc_call_handler() returns val[0] = SMCCC_RET_NOT_SUPPORTED in
> these cases (which seems more likely to be correct). Does this violate the ABI?

Both return NOT_SUPPORTED. val[0] is set to it at the top of the
ARM_SMCCC_ARCH_FEATURES_FUNC_ID case.

>
> > +                                fallthrough;
> > +                        case SPECTRE_UNAFFECTED:
> > +                                val[0] = SMCCC_RET_NOT_REQUIRED;
>
> Is it possible that the (compromised) kernel could have disabled the mitigation
> after the state snapshot was taken? I.e. spectre_v4_state == SPECTRE_MITIGATED
> and the VM doesn't advertise SSBS so it returns SMCCC_RET_NOT_REQUIRED here. But
> the kernel has since turned off the mitigation?

Yes, where the mitigation is the firmware one. The host can disable it
with an ARM_SMCCC_ARCH_WORKAROUND_2 call, which EL2 forwards, and EL2
doesn't enable it again before running the guest. With TF-A that's
only on a Cortex-A76 without SSBS, the only CPU it implements the
dynamic workaround for.

I'll send out a fix. Thanks for spotting this!

Cheers,
/fuad
