Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2EA93BA222
	for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 07:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785395747; cv=pass; b=X3oMK6KMhS2eAZPs+0qFHPmqYZxBR/SgIBoSR4fU620YUa34Tub+fyJMJZaeXG9bAxbwYbb5/YeGIv+8/jH2Ai7MSxHsZoZm5vJ0yFqIoA2XDlgy/UH7reA37rwi9xb1UA+QqIGHbnB6fpPNf8g9s1aDMWlqc0gW/EuJh2jpgCQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785395747; c=relaxed/simple;
	bh=gTs2P4GzAID4bhAr2SIwiMP+u1/EHGaiVI3xg2u1e54=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qb7BKg49ijnN5BC2jA0SDQo+dmpSIwDiomUrvKbHfwTDRfyX/iqLJ4xgbd5k3uW9OJO6pBVfrA1XbHIncLFmyeYeiKyOxBWXDH5DH+A19ZmPGlRzcBCYscYQyiMBZ0BiWuDxVnGJ/TNDtfwlc/t56p3Y1vmOsxPTuEvEazsm9cE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mgZflpnc; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mgZflpnc"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51c15a5b265so195101cf.0
        for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 00:15:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785395743; cv=none;
        d=google.com; s=arc-20260327;
        b=R1o1own0Ei2IvW4V+vqLF2PF0wnMrIZL85ydip17aooxzx7qrXdxuW+w7v0NDkPr5e
         jwG6SznaR7td08PS4z+50szuCZaVr3Tl9LAYei8cEpO3ciXeLpElm40t3C0idd7lDH03
         5cMuh6T2p70Iubi8F+MrTtb1ejKsNvlBlW1MTU+8CNRXBuam7tX05DZ4noNEQb1yGL/f
         iYqsINEdlgaWliKQopDRtmDvrJN0FRF/hiwBrQhKLqZaU89nWyd9JYm3bjhvgwzweHX2
         zotTJam/qgHaV0GTLptUggLjwVbMaVsxFULgfvYWrht13XrFv4aStLbxMB5/Tfbvx8f+
         u1dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rN9nZSu2sgF646io/oXLJaUoy1kgyKi5JGZhp0Svd0s=;
        fh=BpRZ6cO7oIwn73LVabDSdZ5wvp9IjHaHFZRWZLZ0Pxs=;
        b=Xt+6PJLQEDwfdWFoYishD8rhBAWY7XFXhZHBFrWNdbFnwEdvjh+t8sXf7+9bRXN/7m
         IhnhUHwLyxa3I3KWzW49nY/Uag9fUa3ypy2uHVGqAz+TV/20sg1T50cvBmwaMauZoExL
         bZYL9EuqaPs32Zwg7gz9xkQ3BQJrZEOTndFYVWhsu2WDXY9Wy6CInJM62IxKPvdW9cAP
         UZSszOFzAiEFyJSghEr9T8Q4tAh9vtN0c8ql+qHomTCwW/4/t11kV86X6cxPnpPDGuif
         bWOQ6jGkSxzvA09hvpeqBfsQi1m4Y0Guk3/sntHAcZ2VY7R9UNwAgPz/ins3AY2i14en
         zIHA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785395743; x=1786000543; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rN9nZSu2sgF646io/oXLJaUoy1kgyKi5JGZhp0Svd0s=;
        b=mgZflpnc54mr6ghkP2FIWcMguheThCIOyYn7b4JcYvdddQ5mpa+uNfExqMfh6Z4CY6
         KQ4duwqzupefsUDCMfDneJR9ULi+3DfL7UUU7ZFbS/2+OcFr63C/70uvtuMOodKJ3vLH
         +eWbSJcl/NhlYmvN0k9H6VscTLK7ZVEF1qcAM6ClZz5UGgpbTVHKOAtJdNQLVDc9Zq8a
         RYAPXMqtfpY7L4N8BHZVB5Wau1382bZHv/gaBMwI7VorcM+M4vq/knNs249Lh+Gwufb1
         8CgZxh0KiuXS9vshR8kTsCVWR3Aq6yb1P3UcqC3NVgGNM9KQ93N+KJD2r2PIyRNJEBrG
         Yk2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785395743; x=1786000543;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rN9nZSu2sgF646io/oXLJaUoy1kgyKi5JGZhp0Svd0s=;
        b=k7MZXkj4M/f2PAOjrgoEhZIF/1cLaMKPmBNmXYpDPgSSd3TgAXCaMy5ar9oqz/VkRy
         JsnQYkSCb47Civ6uJ5I6ssyfRHpKKCr1aquAYSip06/Y5VlRXiQqBAghP81dPW8QtP0o
         vcliPOFszXD+8ch1By8jr6P2CjxbiIMP8/GxonWIfMQuaSwKO8OkYS5kKb557uFh7eZq
         NRGsMK41olZMoxLIUO9MwTcXvQkiHwKft9ByePVMprrNhvDteiKfADmsLksel/HS4rm2
         XbMGY1DjbeRc8rK6pMhak7cK+u672xG+lDZ1GEr8s/iX6EfzSoy5V0YuJHaFLh1JXV1w
         VfKA==
X-Forwarded-Encrypted: i=1; AHgh+Rr3HnsRk8OTWbWRIO9mTDf5TcvFcz+0OO++cQO+mDI+j9KY1caIOcwS7MKZ9SaH35QHWZORZQ4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxcQ+pc2EySLmDljJiJ53UzwxQ5Oonxjxg5SXYyTJ/ETO5HpBeK
	m22qih1yZQv6IZeHoqZoultSiEwdKs74LWNsVOZwp5/nhinvxnjmxWnf3cG/bMWZ8hwYaTKEoZC
	eu2oDGDRdLrq3OT2FNAPyUCRqnNx6t4wbenJLz7cb
X-Gm-Gg: AR+sD11T75Ls/KdVNwrtXMa+T4lVu2Z/UGrZvjBBGlOLx3jByr8gerd1Tm+ypWY4z9R
	9UtPX39R280CBuYP0HDas1FhVcdMzKz3WCvSLQJgpuqHm4bp4l7JDBjJOR0bGewh0xu0iTzLT+O
	rqr/OIZJRBoJUZ49y6Rxowlnh9ygoSj4fdJQH3f/jqzzEjlzMFf44OZSGU91iAYTJNpw1h5UaaF
	d2pTEAZBSxgzfG7xhM2z3rc5n7L8pB2bX3JkvUp7La8/oQ53BZWgRHbN1+K1s/a1C5Mzq2DXsjG
	bexT6JSdJvpA5Xn+pv7pYyk5YhIgtBdeLO/j5cnqYoRE
X-Received: by 2002:a05:622a:4c0f:b0:50f:af60:3496 with SMTP id
 d75a77b69052e-52b394ab403mr10203301cf.1.1785395742273; Thu, 30 Jul 2026
 00:15:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
 <20260720-hybrid-v9-4-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
 <20260720060858.5AEB11F00A3E@smtp.kernel.org> <CA+EHjTxsm6LorPDR9irVHL0gtmsUG6zUKQLBA2=8Ruy+V4UmBw@mail.gmail.com>
 <1e5e1a1f-51ce-4c0c-8690-b5472cc7bd2e@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <1e5e1a1f-51ce-4c0c-8690-b5472cc7bd2e@rsg.ci.i.u-tokyo.ac.jp>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 30 Jul 2026 08:15:05 +0100
X-Gm-Features: AUfX_mzT91a3nV9pfht0OxPLB6AnFlkwl7Cs0rin5LW0Nvy9x0kjFieO4FqmSfQ
Message-ID: <CA+EHjTyhOqMti7q+OB8S7K-F48iMr9_FntAmW-jvfZmOC5JEHA@mail.gmail.com>
Subject: Re: [PATCH v9 04/16] KVM: arm64: selftests: Test SET_NR_COUNTERS
 after first run
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: sashiko-reviews@lists.linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 30 Jul 2026 at 06:44, Akihiko Odaki
<odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>
> On 2026/07/30 0:23, Fuad Tabba wrote:
> > On Mon, 20 Jul 2026 at 07:09, <sashiko-bot@kernel.org> wrote:
> >>
> >> Thank you for your contribution! Sashiko AI review found 1 potential i=
ssue(s) to consider:
> >> - [Medium] The test ignores the guest's exit state and `ucall` status =
after executing `vcpu_run()`.
> >
> > vcpu_run() does the check.
>
> vcpu_run() itself doesn't. run_vcpu() calls vcpu_run() and then performs
> the check (their names are so confusing here), but the new test bypasses
> run_vcpu() and therefore does not perform the check. I'm planning to
> rework the test to use run_vcpu() with the next version.

So Sashiko was right :) Fixing this would be good, thanks for pointing it o=
ut.

Cheers,
/fuad

>
> Regards,
> Akihiko Odaki
>
> >
> > /fuad
> >
> >> --
> >>
> >> --- Patch [4]: [PATCH v9 04/16] KVM: arm64: selftests: Test SET_NR_COU=
NTERS after first run ---
> >> commit 0382d3a32df9349f988ca69c7b11c92e61c3d384
> >> Author: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
> >>
> >> KVM: arm64: selftests: Test SET_NR_COUNTERS after first run
> >>
> >> This commit adds a regression test that runs one vCPU and then tries t=
o change
> >> the VM-scoped PMU counter count through an idle sibling to verify that
> >> SET_NR_COUNTERS fails with EBUSY once any vCPU has run.
> >>
> >>> diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c =
b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
> >>> index 22223395969e0..3b5bb421f401b 100644
> >>> --- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
> >>> +++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
> >>
> >> [ ... ]
> >>
> >>> @@ -622,6 +627,37 @@ static bool kvm_supports_nr_counters_attr(void)
> >>>        return supported;
> >>>   }
> >>>
> >>> +static void test_set_nr_counters_after_vcpu_run(void)
> >>> +{
> >>> +     struct kvm_vcpu *running_vcpu, *stopped_vcpu;
> >>> +     unsigned int nr_counters =3D 0;
> >>> +     struct kvm_vcpu_init init;
> >>> +     struct kvm_vm *vm;
> >>> +     int ret;
> >>> +     u64 irq =3D 23;
> >>> +
> >>> +     vm =3D vm_create(2);
> >>> +     vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
> >>> +     init.features[0] |=3D BIT(KVM_ARM_VCPU_PMU_V3);
> >>> +     running_vcpu =3D aarch64_vcpu_add(vm, 0, &init, guest_code_done=
);
> >>> +     stopped_vcpu =3D aarch64_vcpu_add(vm, 1, &init, guest_code_done=
);
> >>> +     kvm_arch_vm_finalize_vcpus(vm);
> >>> +
> >>> +     vcpu_device_attr_set(running_vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
> >>> +                          KVM_ARM_VCPU_PMU_V3_IRQ, &irq);
> >>> +     vcpu_device_attr_set(running_vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
> >>> +                          KVM_ARM_VCPU_PMU_V3_INIT, NULL);
> >>> +     vcpu_run(running_vcpu);
> >>
> >> [Severity: Medium]
> >> Does this code need to check the guest's exit state and ucall payload?
> >>
> >> If the guest payload crashes or hits an unexpected exception, this wil=
l silently
> >> ignore the failure and proceed. Since the test only checks for an EBUS=
Y error on
> >> the subsequent ioctl (which will still be returned because the vCPU ha=
s been
> >> run), the test will pass despite the guest crash, potentially masking
> >> virtualization bugs.
> >>
> >>> +
> >>> +     ret =3D __vcpu_device_attr_set(stopped_vcpu, KVM_ARM_VCPU_PMU_V=
3_CTRL,
> >>> +                                  KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTER=
S,
> >>> +                                  &nr_counters);
> >>> +     TEST_ASSERT(ret =3D=3D -1 && errno =3D=3D EBUSY,
> >>> +                 KVM_IOCTL_ERROR(KVM_SET_DEVICE_ATTR, ret));
> >>> +
> >>> +     kvm_vm_free(vm);
> >>> +}
> >>> +
> >>
> >> --
> >> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720-hybri=
d-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp?part=3D4
> >>
>
