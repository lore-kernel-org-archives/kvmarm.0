Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.39
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795447482;
	b=04tXMNe7JT8BmTWRjhl0NgaZFaE5D+L9UD4Xhmy8rMnIydAiV9EYTM1hXiX4VkPNP6nr
	 8I+FLYcwG3CHmsH9iTu7nvuXpsdzjOi8Lj779mV4Upq5K6N6XsAAryhQJh3sBLh/Zvuc+
	 k5AsXYIkea/j7I49zGqMxHYSC+K9ib4R+K+sQ9T2k4Dq9K2KcsFUcj0fapNxji4FDSpi2
	 22/VGAMZD8iFE0fpe1vmpgH2kiq4iARDD/Nlpfe1ZXDhK9asZ5LHvvIfbr2HlDnneDueB
	 ScWSGJbnOPu4YJM0wvUlQ72wAX5KnsNhVzLhd6zyFSpkYyH6gCbY0306dRgjPdZYL5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795447482;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=Hh8fRu5vFtpaCjWKRWOVh0V8299B/cNlEtDS6Intpqo=;
	b=uKG9qMXOooiZZr1o/W5+1KS9qCQbcpH7J019e4Sz+0DKoikZtgBt1B+0PvqPOW/AvoFY
	 XBNjy52uL71vEQ2XtGR4Gf0wIXnNzIj40Rh2uBMD78e33nvsxKMHNHd/FdK7+Q3DrbJ/t
	 Zwc1DgTevbEk6BdCv3tJ34MyMUGqoYMK5EPGFB45R4xb+NzjsPu/h2201/1iXmC80kiW+
	 8FsVTcnIGZyMy9IHXtIuY4CiIsogfqTL+C0t6zt3Gj1YlDQ33Cr7EO+/H+G5gq5Z+K7PU
	 czZ4VKdExTDlhG4nNglYAyZDW2r/g2KrEIeh3pgdgBKaGpuDrHkfxu1ayuYLD1GS4+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=L5OopkFx;
	arc=none smtp.remote-ip=95.215.58.39
Received: from mta1.migadu.com (out-39.mta1.migadu.com [95.215.58.39])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3ADC606A32D
	for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 15:24:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3ADC606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=L5OopkFx
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=gnvbL4VdHXSgoWEMo9YirAKMsnzbccETpFKUkQOB1eY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795447479; v=1; x=1796052279;
 b=L5OopkFxN2htLiqvkdKcaMv2opzBzGrqahToLaMkjMBU7NkrLZJ1q9moBrgwpa6Z8eNipWq0
 ca254RVLa9zltUfG/+rqc20yl02sLKkevHjMachRPxZm16i6HvtOf0OcIfWx5uLnB3wrO7nzE6R
 +X6truUcXp13A+jdWIVZGwdw=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 7dc8b75d9263ca7f;
	Mon, 23 Nov 2026 15:24:39 +0000
X-Mizu-Trace-ID: 7dc8b75d9263ca7f
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5c14bc5a743so12487e87.0
        for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 07:24:35 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEUzA4xdTzPmM1FZggZkuCKKjiIThgDlOJEUaAcfU7gEbxPdcCFgdu4Twu0c/GVPu1TnjqXlAk=@lists.linux.dev
X-Gm-Message-State: APuU4Z8I2uIbPedgc8v5X/aO4OFyv7Yj85r/8G5S1TQpdngCCbD7dlP9
	0BxO0b/xW7OScXUQBurIagS25uwb8uj+IQdYGL4eTom7+NZmV9HAZDCvPkfMhTWQYjz1I1Ps5FY
	b5O9M5Eyl8klL9d0JA11mzUb1b4x4a+in3L6l14eJ
X-Received: by 2002:a05:6512:1591:b0:5c1:4cc8:2f22 with SMTP id
 2adb3069b0e04-5c21a249d31mr226456e87.8.1795447474671; Mon, 23 Nov 2026
 07:24:34 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261123113435.1170711-1-fuad.tabba@linux.dev>
 <20261123113435.1170711-3-fuad.tabba@linux.dev> <awRKhCne0gG1gKZN@gremlin>
In-Reply-To: <awRKhCne0gG1gKZN@gremlin>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 23 Nov 2026 15:23:58 +0000
X-Gmail-Original-Message-ID: <CA+EHjTyM4_P5v0cHEiarq5XAb2A0Esshb762BLuuKnyBvH=y+w@mail.gmail.com>
X-Gm-Features: Aa3M54ohqjfMpFnSPURFY6Wicp7yckb5JMX6NA8ywvncNdbk8_vZnEW0TzRhLu0
Message-ID: <CA+EHjTyM4_P5v0cHEiarq5XAb2A0Esshb762BLuuKnyBvH=y+w@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] KVM: Warn userspace against ioctls while an exit
 is pending
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Wei-Lin Chang <weilin.chang@arm.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atish.patra@linux.dev>, kvm-riscv@lists.infradead.org, 
	Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 23 Nov 2026 at 15:09, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
[...]
> Very much agree with Sean's take here that we should instil sufficient fear in
> users at doing silly things (also in general not only KVM :).
>
> I wonder if we could add some specific examples or broad description of why it's
> unwise for better effect, though? Comments below.
>
> In general though:
>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Thanks!

> > ---
> >  Documentation/virt/kvm/api.rst | 11 +++++++----
> >  1 file changed, 7 insertions(+), 4 deletions(-)
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index 89eb6be9bc6e3..980ef0cdc1c91 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -6974,10 +6974,13 @@ to the byte array.
> >
> >        The pending state of the operation is not preserved in state which is
> >        visible to userspace, thus userspace should ensure that the operation is
> > -      completed before performing a live migration.  Userspace can re-enter the
> > -      guest with an unmasked signal pending or with the immediate_exit field set
> > -      to complete pending operations without allowing any further instructions
> > -      to be executed.
> > +      completed before performing a live migration.  In general, userspace should
> > +      exercise extreme caution when invoking ioctls other than KVM_RUN prior to
> > +      completing the original operation.
>
> Perhaps worth saying why? E.g. (as I understand it) that for these exits the
> operation is only completed on the next KVM_RUN, and that KVM relies on state
> left over from the exit (including parts of struct kvm_run such as exit_reason)
> to do so, so any ioctl invoked in between might clobber that state?
>
> I see you intentionally avoided documenting the pre-fault case on its own, but
> with the above stated I think a concrete example might be example here, like
> e.g.:
>
> "For example, if you were to ... that would result in ... which would absolutely
> ruin your day because ..."
>
> Kinda thing :)

:)

I'm not sure it would help, tbh. I think a reason or an example would
have the effect Sean wanted to avoid [1], where a reader takes an
ioctl that doesn't match it to be safe.

Cheers,
/fuad

[1] https://lore.kernel.org/all/av5CBjbeidUUWiLq@seanjc-mac.roam.internal/
