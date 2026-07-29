Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91DC4779BE
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 15:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785338635; cv=pass; b=BCm+yEiS1eWrlVgKLMAtWH3FIkZpbuRdrIR/xZKtoTzwaDnlWLyEmQbLF3XDBcF2A99tIRYmyyKK7z3uYDhUFSgeJNocEdNsN3lnscqs9oIgpIpQmZ7nzzjX5j0OtERAk4REHhiV6KM2vkmpIFVt4gWXsK614wPAm6RClq2W+74=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785338635; c=relaxed/simple;
	bh=KvR+cddFigOMJS06ugQoH4iVC4ve1rtPkVOdtPRomp0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jUiEVU39U5/+3kYMvJxu68ZCyI7cLrsySIQqthmCISd/r+cVXBy9QGYZT7jqoat8EuHbElsFFhrhV775lyE260SNFCo5rAoMouIOjOG6jJhXOiwsPl1m9HImNNhCSS/bxMMl6/uCyRwpefES/SdcUd6G2HgDXxyumS+d7K+SS54=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=heTIHQHk; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="heTIHQHk"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51c10ed63c0so315011cf.1
        for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 08:23:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785338633; cv=none;
        d=google.com; s=arc-20260327;
        b=Gyt/mraJlgQozcPkXLVVdfcMUIlg8cygFmKYWasRpFxlKIQl5LpWpa6lZ7kMK87rQX
         8nzKx6lIAFohfO2I6cABA74xw9VViiXroYGVKrTQhWjfKUJoT9r97otqIcYlDus5pDgL
         lxh8yZ6QTaWuk9cR7X/uA42twIdYkBxkWLwK16/vWvGEyVi3LhCxkKWZhXvGoAil03m7
         TpBm51OHO6NKLj/aAMUUDm7dY9nrS10i5Z8D3Qtn6Cp6L7fIRvgBj8+0RLOFTprNXbC4
         XWksLkDtRgyTw9bt8JkHgZXHT2HrTy3Z0OItvUB5Y6jLsYUurt6Ulc1Yis8nADeHUvTQ
         /+zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=751kHf3xuWyu+wd3aooaxL29DUmLoKaYZairhF8FZOo=;
        fh=GjBxrbB6wVxommHUpU190asATcZDjTkfJkwGRBvdn0k=;
        b=U9MEivDQUv92idrDd2TLUvjkVu1fhgjLsF5JPuwNfZGdyin2vmKbYCYN6Nmk0VbsLp
         JFU9lv3U/KGZlWf0J+zvAS20wDSpKJLgeyqYvZaeEanW7xUHi82Ie0h7KMv1P0+8EEg+
         qNHpJc41PVQFWSeIKT6utFoqjRWzCWVVqI+PDLfQ4op0rE8LTBiBdwrdil9x1SuUw+7n
         R/kraKuBoCOMIrItl1nu8qQAvTnSXOBRgqGVfxRuWu1iwRNb7tr3WDjVWHetl5Oz48m8
         tJzKwQGRVQo+ZdIQaLG8PNFdCt9Mz+oZtFQn09pPNcJdEIJ6I8u1Fq9J20P+PDXeNnPY
         c+QQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785338633; x=1785943433; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=751kHf3xuWyu+wd3aooaxL29DUmLoKaYZairhF8FZOo=;
        b=heTIHQHkSrlnbg5vdXlzb/B+SgtliNt4SoBnXyZcg6N8EHpGzfFlvgK6U/ZbdMCGHQ
         7C05biN8fKB/1aDiG91k0USKzFqz2M3Io2aYZpIen3b2PjJut9TPEmQhWSOMaARY9wdN
         K2KtQAb9RUYJ5SjFpHL9Xdlh13jZ3A36NsO5R0EyfS2gSBBLpXXAqW5VP7901UMo2CbW
         qW/hdNmu3rJFlRuTCWdcM167vVbl1YzO/hWIRqJGfsY4RIpqSSwEmSyC9HeGz72cQ3bf
         APi6SSQJxRSQuaLvo1xuB3x40g6nlRD/3sfKnT7U+KBX4RsX0Fb59yR9w1rFPoj7QTZQ
         hQhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785338633; x=1785943433;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=751kHf3xuWyu+wd3aooaxL29DUmLoKaYZairhF8FZOo=;
        b=gXuM8dzv08V7upXZ/euXFpXjSkB8CCgxege1fYs+9YQQ2B3trv0uFWcIjb8mXmCEaH
         FYc7yPVYB+rLUi/hnKBkPPQ20b/Ms/UV6+MPJQdsxg+LQR77S+s0RQNsASkZqsXoBy5E
         rf1KsDgslXCQJSS7nbyLgE7206GPpSxdKxIcRIO9IZcLcb1YH/YR25VeynVW6drCSXgp
         tzExCTqt6eDQxaxLPhxaMBTJ1SahIfoyC9ti4C2c7VqPRuiBaJN81AeCLlgk1OkLcyVC
         HbLPio6guTLxrWKOiE/L5ufSRdwI6s26kAcf1d7EQtK4jjoEdm/SGKnd7DakdM0rWU5E
         X56w==
X-Forwarded-Encrypted: i=1; AHgh+RpmZunJOWgb4My1RSdN54XS8cW8Et2gMAt+pZ17Tbvi9D3alDH07QLWVibJ6GOAHIW+iPhbbW8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyAH05SPtRiGBUgiICf5O3tHeDwdrmmh/sLRz4VbX6ub7CMbby6
	dbygkfrsWoahyfrapwBHocmp+9ZtP236C435JplBcl9b+q4s7x1fhQn5AQY7gbYP2Lnltyw7GEr
	opZUxzpZIJzXAJ3AZknEOuyQonu6FrH3bSpIk2MtE
X-Gm-Gg: AR+sD11UFGYn5+4C/i4+yf/g2T2XCdGv7gT41zXVo+z/ExapC8fTpKiC3uWctOGH9yW
	ofJ7YnBP0uR1m2/14GVuJ1MacMb65BgqpbV39dG+cnfuKPW3Sc+jNkUwEQdvjWYU2Dny4uYYF0O
	9VLUSuLx86jBPnAwbxIdRBzcKeVgPu+Q8IzaMlr3PzhGciThtoDWUmFVjs9FSwBNFoo1VZFbEg5
	YLO/rN0NmhsIRIZpmV9vaxQc+OD5d3OJPYLXtac9KHltDQxrduBAoqVQVJ79LorD+hdfEaTo4Em
	f8W+Go4AsZ4c9wV55ugWi6v/QXqnpuwpZrnNvF2TAY2d81NNI0/+QmEUYlXxYqB05QZ+7qCJ8Kg
	=
X-Received: by 2002:a05:622a:2610:b0:517:6dc0:698d with SMTP id
 d75a77b69052e-52b34ce6830mr1188171cf.0.1785338630160; Wed, 29 Jul 2026
 08:23:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
 <20260720-hybrid-v9-4-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp> <20260720060858.5AEB11F00A3E@smtp.kernel.org>
In-Reply-To: <20260720060858.5AEB11F00A3E@smtp.kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 29 Jul 2026 16:23:13 +0100
X-Gm-Features: AUfX_myAm_s5RN5CqoGtHGgWFh1C3i89D3rZXWu2TLWc1vxbN2Jerqq4ksz8e38
Message-ID: <CA+EHjTxsm6LorPDR9irVHL0gtmsUG6zUKQLBA2=8Ruy+V4UmBw@mail.gmail.com>
Subject: Re: [PATCH v9 04/16] KVM: arm64: selftests: Test SET_NR_COUNTERS
 after first run
To: sashiko-reviews@lists.linux.dev
Cc: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Jul 2026 at 07:09, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Medium] The test ignores the guest's exit state and `ucall` status aft=
er executing `vcpu_run()`.

vcpu_run() does the check.

/fuad

> --
>
> --- Patch [4]: [PATCH v9 04/16] KVM: arm64: selftests: Test SET_NR_COUNTE=
RS after first run ---
> commit 0382d3a32df9349f988ca69c7b11c92e61c3d384
> Author: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
>
> KVM: arm64: selftests: Test SET_NR_COUNTERS after first run
>
> This commit adds a regression test that runs one vCPU and then tries to c=
hange
> the VM-scoped PMU counter count through an idle sibling to verify that
> SET_NR_COUNTERS fails with EBUSY once any vCPU has run.
>
> > diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/=
tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
> > index 22223395969e0..3b5bb421f401b 100644
> > --- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
> > +++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
>
> [ ... ]
>
> > @@ -622,6 +627,37 @@ static bool kvm_supports_nr_counters_attr(void)
> >       return supported;
> >  }
> >
> > +static void test_set_nr_counters_after_vcpu_run(void)
> > +{
> > +     struct kvm_vcpu *running_vcpu, *stopped_vcpu;
> > +     unsigned int nr_counters =3D 0;
> > +     struct kvm_vcpu_init init;
> > +     struct kvm_vm *vm;
> > +     int ret;
> > +     u64 irq =3D 23;
> > +
> > +     vm =3D vm_create(2);
> > +     vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
> > +     init.features[0] |=3D BIT(KVM_ARM_VCPU_PMU_V3);
> > +     running_vcpu =3D aarch64_vcpu_add(vm, 0, &init, guest_code_done);
> > +     stopped_vcpu =3D aarch64_vcpu_add(vm, 1, &init, guest_code_done);
> > +     kvm_arch_vm_finalize_vcpus(vm);
> > +
> > +     vcpu_device_attr_set(running_vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
> > +                          KVM_ARM_VCPU_PMU_V3_IRQ, &irq);
> > +     vcpu_device_attr_set(running_vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
> > +                          KVM_ARM_VCPU_PMU_V3_INIT, NULL);
> > +     vcpu_run(running_vcpu);
>
> [Severity: Medium]
> Does this code need to check the guest's exit state and ucall payload?
>
> If the guest payload crashes or hits an unexpected exception, this will s=
ilently
> ignore the failure and proceed. Since the test only checks for an EBUSY e=
rror on
> the subsequent ioctl (which will still be returned because the vCPU has b=
een
> run), the test will pass despite the guest crash, potentially masking
> virtualization bugs.
>
> > +
> > +     ret =3D __vcpu_device_attr_set(stopped_vcpu, KVM_ARM_VCPU_PMU_V3_=
CTRL,
> > +                                  KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS,
> > +                                  &nr_counters);
> > +     TEST_ASSERT(ret =3D=3D -1 && errno =3D=3D EBUSY,
> > +                 KVM_IOCTL_ERROR(KVM_SET_DEVICE_ATTR, ret));
> > +
> > +     kvm_vm_free(vm);
> > +}
> > +
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720-hybrid-v=
9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp?part=3D4
>
