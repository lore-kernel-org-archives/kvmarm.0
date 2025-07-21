Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12CD29827B
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 11:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753096453; cv=none; b=Eo9SgI7MvrxH+cYeI6+7ZLs4vDh17YxkmqJQuQ3KRy34fahegs9So5uk6v6FFJ42lxMu4MqjgKC33NjjqsfLcS3GOPiYLCwS6XDh2ML8jbUrCkEC5ARGoLONZ4jQcgsFV5u/zTIUIjNkYUfSs4kxIC+9SSXncJdIgn4Df1D8/e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753096453; c=relaxed/simple;
	bh=fLbKWdOARv40pCY4qGliofKyRxzK3AsCP0pWclC3jfw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KtdK3g1MfEE1nM6w4JWML7Dx4s9o7UBQU9Y4v/XEsqZeaArQ5H2OZV7JvUQNsWFogGqTkMCFVbx4w+3vuHOYzNZJZz2ncbp6xiZkruf/fNwTa8VEkCNJT6fDBzOBEVOLox5VR/IeyU0Lc/g3LMHVUwCaliGGjZ0UWDB9LXnHF7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=android.com; spf=pass smtp.mailfrom=android.com; dkim=pass (2048-bit key) header.d=android.com header.i=@android.com header.b=bceNxXic; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=android.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=android.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=android.com header.i=@android.com header.b="bceNxXic"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6fafb6899c2so49108476d6.0
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 04:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20230601; t=1753096451; x=1753701251; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GtlRa4EnHRvRTTXOu323ubV7Cd4GPOUPDvFH3dEXzK8=;
        b=bceNxXic8fK9QafU3uppmpFHNe8abUFouKCoHQlR5gyeV90ckrcnNsNZ+1LXkFqGSK
         xLXwFQP10lnPDfjRoBTlVdr+T29n6IN45hyp2SQhMDMOAtmXr4NAjXq5p5LQaHgt/k8v
         5DYvIIy4TlfCLZdZ9QJc/aJRgtzjsu9LjrhQ70fdeoaEprP6fWW7lCVBo0eCBIJsfsXc
         zGAL7/a7YGcAc5bXHPq2qJJ7woUOhR8QKTC+sKN0skB06Ua+C4B25m6k9Kdk/YXftXe1
         SaegzQ4W1LvO+QwYXHQv6dy93WJUVFNGQo0gnlnEdzVb8T/Des9R3D+fV3Q5oFXkA81c
         lAFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753096451; x=1753701251;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GtlRa4EnHRvRTTXOu323ubV7Cd4GPOUPDvFH3dEXzK8=;
        b=wZQQpzKmP8Bw847mCV3v1/kGSEqZu+jKm23gMLB/S7V16C63Jz6p0c/1mcGvo/j3ak
         5tcUgrKtraRpOzKZm8gAvTtZ9gzCXA2PWwzrhtOstelBO/kAZ2zacr5IuBybfvZnUjt4
         pIhPVT0tL8ca7rv2DfowuWdamH0vrte0hFW+I6BMcQax6dLd3GBwfqF5Co5S5VfCVv2V
         BTgvnrLvp1l3/R1S/GjBuMd4CPFI6+eGYYC6dYl+WtMxcPGo0GCSQMewEVcmDux/y6jc
         EuK9vJPlUZgzMEobRUlUwHjFXqkVokYAvU86znbbQsnTNsW+twK/4TMZWC/363Pi4hB/
         rPsA==
X-Forwarded-Encrypted: i=1; AJvYcCUl4gS1Fda6yW6XAoTEM/U3fDKd68CXuCti/f6+j1AbCpOq282nK7rSi6F5pKBNlOHpsLy0Bww=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6wG4PM1OIiDiwHFwe1xv8SklGo9rECqg5q1Orr9bdXY3LdPMe
	PKJN97aCVQxmpb3Lr7lqU3a+RGiV5q5mHnAdOBGkOKp5YO1A1bxMoz7mVuKizSrfMLP/ise8+mi
	gthbMN0hz1Wz7w1huP3oHK2RBJfmVKhDb1SjmR0em
X-Gm-Gg: ASbGncu1lpaHP2/GuGE0OLSRDm9GOQ8VIaO/Q3REOm64tUzoAVFRyJMcTKItkxsMlPM
	obkbg4uG1HTb8yYgw4IT+s7syN8j2sQYEpn6JSVyB/DRvXlCnsoO3zJE7XR0QsrBtcmQBNsroQV
	y6RhYLDWZBjwjDjzAPu52Lg+L/FxOb7LfteMj+bp71z5A3cHWzB+6TsSMrbls1gpknr0LhPPK3S
	I0b6YuiXFHXE0jmuuhiiTM/USEYbJhFBMe04HWMNA==
X-Google-Smtp-Source: AGHT+IF/Z0HI6TmXWcSejGmxIumXwzv7Wt4N9tNfpJJWx7Y46lpv4IgUdvc+GB5ne/UGCDyxnW+oQUgbgPZJGkXl9xU=
X-Received: by 2002:a05:6214:3305:b0:704:f44a:75ff with SMTP id
 6a1803df08f44-705162103c4mr156533906d6.22.1753096450633; Mon, 21 Jul 2025
 04:14:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250701-virtio-msg-ffa-v7-0-995afc3d385e@google.com>
 <20250701-virtio-msg-ffa-v7-5-995afc3d385e@google.com> <aHpRvBO864x1vvqP@willie-the-truck>
In-Reply-To: <aHpRvBO864x1vvqP@willie-the-truck>
From: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>
Date: Mon, 21 Jul 2025 04:13:59 -0700
X-Gm-Features: Ac12FXyFG5yEbBpu73BqZFIB9DdaO3n1VasDGNS_MIwe8KNKSUyKkMDnLJwSvog
Message-ID: <CAMP5XgenLo3dk=NB-iJ4MLs5azB7w=0RHkbQJRGb_qMnixCTsQ@mail.gmail.com>
Subject: Re: [PATCH v7 5/5] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ2 in
 host handler
To: Will Deacon <will@kernel.org>
Cc: perlarsen@google.com, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Sudeep Holla <sudeep.holla@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, ahomescu@google.com, armellel@google.com, 
	ayrton@google.com, qperret@google.com, sebastianene@google.com, 
	qwandor@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 18, 2025 at 6:53=E2=80=AFAM Will Deacon <will@kernel.org> wrote=
:
>
> On Tue, Jul 01, 2025 at 10:06:38PM +0000, Per Larsen via B4 Relay wrote:
> > From: Per Larsen <perlarsen@google.com>
> >
> > FF-A 1.2 adds the DIRECT_REQ2 messaging interface which is similar to
> > the existing FFA_MSG_SEND_DIRECT_{REQ,RESP} functions except that it
> > uses the SMC calling convention v1.2 which allows calls to use x4-x17 a=
s
> > argument and return registers. Add support for FFA_MSG_SEND_DIRECT_REQ2
> > in the host ffa handler.
> >
> > Signed-off-by: Per Larsen <perlarsen@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 24 +++++++++++++++++++++++-
> >  include/linux/arm_ffa.h       |  2 ++
> >  2 files changed, 25 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ff=
a.c
> > index 79d834120a3f3d26e17e9170c60012b60c6f5a5e..21225988a9365219ccfd69e=
8e599d7403b5cdf05 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > @@ -679,7 +679,6 @@ static bool ffa_call_supported(u64 func_id)
> >       case FFA_NOTIFICATION_GET:
> >       case FFA_NOTIFICATION_INFO_GET:
> >       /* Optional interfaces added in FF-A 1.2 */
> > -     case FFA_MSG_SEND_DIRECT_REQ2:          /* Optional per 7.5.1 */
>
> I think that's the only change needed. In fact, maybe just don't add it
> in the earlier patch?
>
> >       case FFA_MSG_SEND_DIRECT_RESP2:         /* Optional per 7.5.1 */
> >       case FFA_CONSOLE_LOG:                   /* Optional per 13.1: not=
 in Table 13.1 */
> >       case FFA_PARTITION_INFO_GET_REGS:       /* Optional for virtual i=
nstances per 13.1 */
> > @@ -862,6 +861,22 @@ static void do_ffa_part_get(struct arm_smccc_1_2_r=
egs *res,
> >       hyp_spin_unlock(&host_buffers.lock);
> >  }
> >
> > +static void do_ffa_direct_msg2(struct arm_smccc_1_2_regs *regs,
> > +                            struct kvm_cpu_context *ctxt,
> > +                            u64 vm_handle)
> > +{
> > +     DECLARE_REG(u32, endp, ctxt, 1);
> > +
> > +     struct arm_smccc_1_2_regs *args =3D (void *)&ctxt->regs.regs[0];
> > +
> > +     if (FIELD_GET(FFA_SRC_ENDPOINT_MASK, endp) !=3D vm_handle) {
> > +             ffa_to_smccc_error(regs, FFA_RET_INVALID_PARAMETERS);
> > +             return;
> > +     }
>
> Why do we care about checking the src id? We don't check that for
> FFA_MSG_SEND_DIRECT_REQ and I don't think we need to care about it here
> either.
>
> Will

I think not checking the src id for FFA_MSG_SEND_DIRECT_REQ is a bug
that should be fixed as well. The receiver expects the hypervisor to
have validated this. If the src id is not validated here then the host
can impersonate other VMs or even the hypervisor itself. This bug
might be minor at the moment since other VMs can't send messages at
the moment, but it is still a bug that needs to be fixed at some
point.

--=20
Arve Hj=C3=B8nnev=C3=A5g
