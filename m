Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FAE2D5419
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 13:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768224570; cv=pass; b=Qv6AyLv7cTvgWPBIpzCTN7MD1By9hxU20UUgHYJxYk1uAxhkupALNxNrKw+nMM3HiS5AG5JdmrfzXCyztY2zft/Y9K4re3NZSkBZ+ok6V8+Gpf5r5ql98Pj2mtVRUtcyuOx94gnamKm71weIkEF40vffvBM6/H0/AtCR61XFAF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768224570; c=relaxed/simple;
	bh=nNsvMblRGGki6ohemJFCJRABNbnFZNgKUtyaxPDO2cs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KdxouPsoCy5JFsQoQ3lKlRfYOM5ZB4Yg9wMCNcxl7UmW9zHjKBAzFrmDbkZLCHqduYXduxmHjgdjO8wUoTdaLTy6Rxti7lNKymQ96exRHJtbmIPyGR0Z2SS/tLvYOEa65bjS15uNWVshavSKpwcVeOpMPmD3l7s9OEX3AMWX9hU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kxwnR+UE; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kxwnR+UE"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ffbaaafac4so931181cf.0
        for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 05:29:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768224568; cv=none;
        d=google.com; s=arc-20240605;
        b=NCgb2GVfAejkHnzbuluAHILD5t17sWd18ril3lf2T47HqW0UXEbDc51a+rjwFM8QUd
         5z+qOvJb6u6mMcFfCvNVEwC8OXOOlcwvlYYW8IIakK87dCRUdETQVKO7BGeTKNmkv1xh
         ugveOJ7DtIm1yvkuDr8LB0U6qbXWabcLyG47AljTIS/gzJGosDx0omackIogMBQd7+oz
         yaP1koW45ZcznC619ef94YDU5rmS3Qu/67mV8VTFRnjQa/WX5ytk0E6hfaMuLkmVyqx1
         lhZSOn4M5xAldJW8hOkJJ6hmA/gDDL1wASiX3A0xAFxEcFun3yFcgKs6gf+lIbqR7rUT
         b8wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jaGuPXqFXeyZwxS5wActQiEFDVDRQPMhfrfAWEZUdIY=;
        fh=YCWAQUMi6K5xxJcLt6eytgPHVd867GntVYeqXtcc9PI=;
        b=Rt/X32vU5SuDag9WskL6KJd8+u5o4cnfA259UuJnsTdUtpZ68PWedEeT6qUoE3hSJX
         QSBHMHUnVFnzvJDZXMz6ccxoawWO+FB2fjTs2sJyCbwWjRb/cksF4Sq7zB1ToJoIwu1j
         lZPmEezS5E3H9+HcSovngNKLyfn/6vW2wXJNxsL8qMS8YPrV+MGURv8Luf+LRhTG5IqV
         TWkMecAfij9d7iLjfXUctOV2szNdETXexdFeBk4bIl/sgJ97d3zf8PT4jDcXXBj8YlrM
         J8HNN2sIHzJQUYLca+jjogp+Sb0Z4FRkN0onMMAwN+eno6je/sPMcMB6n9MkQCLDc2Pu
         MXuQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768224568; x=1768829368; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jaGuPXqFXeyZwxS5wActQiEFDVDRQPMhfrfAWEZUdIY=;
        b=kxwnR+UE7uC/3qOGMb1qmswuM0fDdm6UgIcbxfthZI3+8ElFCxnbqGz4AVpmCaXl3g
         M+2o/5uI3eaQnlf3qDXXPTDPwQwi2mM5bqshdBf0ZYA1GsjFt1uwIX03LsvY3pq40SJ0
         H3mWJSdsLClLJ0yq9eerClxXTNuwmXDZrrqARy3btM4+m/pXnK9lYuZiqAsb6odnKR9p
         zb5ZvU1qROijsz/2Y0sYS+hPB06uxQI3/GYVlg3eXCidHQ0J4puABV/dZwkYoVFo5qAv
         jGW+E2Z9CA7dEVU3UaouwX37wkmsB/Hmjtzg+0BCrPUiP1K47VN7SQgdkGQdaLbUJyl5
         HKvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768224568; x=1768829368;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jaGuPXqFXeyZwxS5wActQiEFDVDRQPMhfrfAWEZUdIY=;
        b=ARZaTAhXw60zn+dWynyAqJCeSvLd4ZvJusUXtqzga9rFbkyEjF5RyuplxO/gzadwRL
         ev56Mx6ElyDGRrNV50I+qIJArfFukbA8m0/1DpG11Kf/tBS9ccqBZWkIY21dS3WY1lXb
         880biGWxyxI69dL5RSkwjDkXSdWmmb5VNBKesh4OodEXWt3cyhZHrdTZ4D7o/bIivIPM
         b3FeMPSs/NyGztz4KU3kUPfUPDYOaERxVcAfCq0KvMrQEEdi4arf6q4AGFbrP5JlF3sq
         ekzXWmS3+DRu+LTZ9DGdlpX0L9KimJTuiLm2Bpn38xtTC+ifBC0tJxWPYvPgMg+rJXUm
         Stow==
X-Forwarded-Encrypted: i=1; AJvYcCWviTTxOGPDTfsxxj/mQCVhcVriJ+rSvfJ3vkhC7yFj8ElOtVWkr2omDKjsMA8Za8eS9dDuuyE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yww/sZ8KdUeFR7KCJkDY/fxOV31FoQcCYTT6eN/fqK4nDwj6PKU
	0BDV+c3ouejaACDu7gBU3g/xXO98yh66fXfy/Jxk2AfjGj/7EnPN1bYPeF5/+QcjXKVJGeKRPAh
	zzDa0u9QNc15urA8iZtbbZrkhIjoLRz5rU27jzGNu
X-Gm-Gg: AY/fxX7b+EyTRtIcE4T6Mgw7Q5iL/EEJEEkqRUidxF/WT6HuIMCrbdFdW8t5//0qp0k
	eChUuD7+iT9v/DcT+2F+f07NnIXGX3WgULfKfmHkj47+9BdcKvEF9mnURpjUXHv1/cMuTHXZ9mn
	6px+jSjnEQSO2Of1NjNqlmUkUEIOEJFyjYF7xKl7zaq/ZGkc0ezozkndfouuZcV9PObQ9yh4rVs
	S62BzzTn5HbWMuBMszTa5SJusfCbObPPWaLtm77y7ArS/jxw65m2BBFUnScrNjDJ9IUE6FP
X-Received: by 2002:ac8:5891:0:b0:4ff:bfdd:3f46 with SMTP id
 d75a77b69052e-5011979b086mr18062621cf.15.1768224567393; Mon, 12 Jan 2026
 05:29:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org>
 <20251223-kvm-arm64-sme-v9-14-8be3867cb883@kernel.org> <CA+EHjTw-6-BFcr60+tgDzOE-OfcetD7yQtbNMkqr7BgiMXfeJA@mail.gmail.com>
 <96efc90e-bf1f-4b87-ab7b-0e24970eb967@sirena.org.uk>
In-Reply-To: <96efc90e-bf1f-4b87-ab7b-0e24970eb967@sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 12 Jan 2026 13:28:51 +0000
X-Gm-Features: AZwV_Qhr0cnxEyY0NvApe2jyI_fTASUjPe1TmX1ATOL61XV_IRaHe4gUVPwKxys
Message-ID: <CA+EHjTxQUADWmCbSgUiFcXz_BxDPLE+THHnF6Mwx73hnhc7OJw@mail.gmail.com>
Subject: Re: [PATCH v9 14/30] KVM: arm64: Implement SME vector length configuration
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>, 
	Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 12 Jan 2026 at 13:27, Mark Brown <broonie@kernel.org> wrote:
>
> On Fri, Jan 09, 2026 at 03:59:00PM +0000, Fuad Tabba wrote:
> > On Tue, 23 Dec 2025 at 01:22, Mark Brown <broonie@kernel.org> wrote:
>
> > > +
> > > +#define vcpu_cur_sve_vl(vcpu) (vcpu_in_streaming_mode(vcpu) ? \
> > > +                              vcpu_sme_max_vl(vcpu) : vcpu_sve_max_vl(vcpu))
>
> > nit: This isn't really the current VL, but the current max VL. That
> > said, I don't think 'cur_max` is a better name. Maybe a comment or
> > something?
>
> It is the current VL for the hypervisor and what we present to
> userspace, EL1 can reduce the VL that it sees to something lower if the
> hardware supports that but as far as the hypervisor is concerned the VL
> is always whatever is configured at EL2.  We can obviously infer what
> the guest is doing internally but we never really interact with it.  The
> existing code doesn't really have a concept of current VL since with SVE
> only the hypervisor set VL is always the SVE VL, it often refers to the
> maximum VL when it means the VL the hypervisor works with.
>
> > > +       if (WARN_ON(vcpu->arch.sve_state || vcpu->arch.sme_state))
> > > +               return -EINVAL;
> > > +
>
> > Can this ever happen? kvm_arm_vcpu_vec_finalized() is checked above,
> > and vcpu->arch.{sve,sme}_state are only assigned in
> > kvm_vcpu_finalize_vec() immediately before setting the finalized flag.
>
> I don't expect it to, hence why it's a WARN_ON.

I understand. My point is, by code inspection we can demonstrate that
this isn't needed.

Cheers,
/fuad
