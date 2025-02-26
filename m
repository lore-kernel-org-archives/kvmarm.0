Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA315226D03
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 09:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740561527; cv=none; b=ttffFVtjg+/QirqaIjAR+J0cvD9bITz1oAOjim2RZq0193d61u/BvIRS3ToHuVuOsdww9UWHPzVedJSwLhi3EupkaQ8Iut4WqHmWayk3fKRMe5/GtuXVJGk2aElRtRF+XUcx25+EVmht6tKcTUezKX4FdFaGUr3KztLiTyZ/r6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740561527; c=relaxed/simple;
	bh=5zEfvEUUsLGTCHX4AwEafQpReN3akvlINVbTahuLpDc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DdzTBKCoioGnfbnlzlcpY0bVUUfUcQErG+Sux78XCYUKhMXlIe9+TZEdPicWTbcgopXHA/VWF4OGE0a85Io2ASg9Vr26ZlGg6htpSn9C+Xd1ffgD4sjdmDxxIhPLhPk3wWrt/HZq5UKzLwNzd6+pfAxDlRdjgJxLTMN+hzAzo6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NfFHzAIX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NfFHzAIX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740561523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0MIbia0vRPyl/EASI4bbBzkpXlN9D9cFmNZ+w8QhjMs=;
	b=NfFHzAIXISkgCm3u6qfcMrCAga246qeMtuEY3V4zFReCSv9Y9mLZuN1YYATNLjvFxXD9h9
	ddHBnlx45mCgqZKt1BUmmmgfMkSbHDLeAF2cu4OgrtRQhbqQsqNpTDjBJtHBa5htorvCtC
	AGCFED36x9lp8nLUoLL8dCVNU1KADtE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-TasiVx2sMWuvn4EkxJLBfg-1; Wed, 26 Feb 2025 04:18:39 -0500
X-MC-Unique: TasiVx2sMWuvn4EkxJLBfg-1
X-Mimecast-MFC-AGG-ID: TasiVx2sMWuvn4EkxJLBfg_1740561518
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-38f27bddeeeso6823150f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 01:18:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740561518; x=1741166318;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0MIbia0vRPyl/EASI4bbBzkpXlN9D9cFmNZ+w8QhjMs=;
        b=wPauIe/mI9LIzRWHF4F3153yge4eheJRBGHzZAMZI3/Qjdd6yIlqo+C55AaPwiQJpM
         bMMj5Is+Nppqbc5cvY5xyqbUEq0sOF+Euc0tc5Ti1aYJP1egGu9c8lSQepm/VGBwQccq
         Q1redu+JMKLizcey9FZL2CaFdHMe/KhqnUn16uqt3c26x9C9RSbEifugkuDd0o3w0B2B
         LL1ETGHyCG4qd2F+qo3QjPId7fy1qHsboQ4gK22pydmK+bXCS5pJrKrTBOQH2AFaX9qe
         H+gX2NIPOZQWLoICeJaBwEXxyWcSsWtDT1ibAw93NIj77u+UTmEmZhOl5iZrzFhju9KQ
         6eJw==
X-Forwarded-Encrypted: i=1; AJvYcCUAsBtjabt+OQrLtp3LwxlrBh7qxvI+a6hvDZ/Y6DDnVqJXTLSdwOmCbwmADiWzr59kdrOnN/M=@lists.linux.dev
X-Gm-Message-State: AOJu0YwWfh84GBnVRZs1pfSQel50r2JjXYNycbU8GztNoxJY7aEJSqb1
	KWoQX6vuSmjD1nfKmYBcZDN9ofTXwjFjvGOuF/VAjcvQPok7bkmY5b6viYE7ma0zCWXFpUpFzBb
	Xm79TWG11/hwNX2Kx7g1PpUy5/FnBHZtQenlmAAMcwgcPU0RS2Oyfw+0GWlqB2TnOj2gn4c8MTA
	iRSXVj5J0eqSTBOnF/TN+/wXRht/CX
X-Gm-Gg: ASbGnctu6DmeO/FdMC8Vma79k60VHPrxvANnbeUMUhtKfyaTqDx+fDHXfoL6IzSD6Or
	zQoTxdjOz8g2ZVHEeV1IALAA6gss7Is/Pu1a9L0cF3Abn3PA0j2VsY9GsFy7QWSPKbNsxExk+5w
	==
X-Received: by 2002:a5d:47af:0:b0:390:d61c:c777 with SMTP id ffacd0b85a97d-390d61cc85fmr1296765f8f.46.1740561517831;
        Wed, 26 Feb 2025 01:18:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGM8QJcltKK3icbvaiTIyjEom27+uMjjmS3V6slM8kbmQaHs57lufLQIp1ODz/r9AND77qyPMNyl+BQOe7Hd40=
X-Received: by 2002:a5d:47af:0:b0:390:d61c:c777 with SMTP id
 ffacd0b85a97d-390d61cc85fmr1296733f8f.46.1740561517436; Wed, 26 Feb 2025
 01:18:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250224235542.2562848-1-seanjc@google.com> <20250224235542.2562848-2-seanjc@google.com>
 <6475f9c7-304a-4e0b-8000-3dc5c8e718e9@redhat.com> <Z75f9GuA9NfKo37c@google.com>
In-Reply-To: <Z75f9GuA9NfKo37c@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 26 Feb 2025 10:18:26 +0100
X-Gm-Features: AQ5f1JqpfKleIgYhNDBuhYOTkE7mUvo6hlKxjC4ts72PAS8Q4WmxhhjJCWdlkGA
Message-ID: <CABgObfZWqBm089dkOpWwX-d6Bgp84zP_0Gow4ow7ZKHov=8oxg@mail.gmail.com>
Subject: Re: [PATCH 1/7] KVM: x86: Free vCPUs before freeing VM state
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>, 
	Jim Mattson <jmattson@google.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _cPVTMovd2fKu6fBeSZugEPNqi6ZxHUPhi-jhS1Z7RA_1740561518
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 26, 2025 at 1:27=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Feb 26, 2025, Paolo Bonzini wrote:
> > On 2/25/25 00:55, Sean Christopherson wrote:
> > > Free vCPUs before freeing any VM state, as both SVM and VMX may acces=
s
> > > VM state when "freeing" a vCPU that is currently "in" L2, i.e. that n=
eeds
> > > to be kicked out of nested guest mode.
> > >
> > > Commit 6fcee03df6a1 ("KVM: x86: avoid loading a vCPU after .vm_destro=
y was
> > > called") partially fixed the issue, but for unknown reasons only move=
d the
> > > MMU unloading before VM destruction.  Complete the change, and free a=
ll
> > > vCPU state prior to destroying VM state, as nVMX accesses even more s=
tate
> > > than nSVM.
> >
> > I applied this to kvm-coco-queue, I will place it in kvm/master too unl=
ess
> > you shout.
>
> Depends on what "this" is :-)
>
> My plan/hope is to land patches 1 and 2 in 6.14, i.e. in kvm/master

I meant only 1, but if you want to have 2 as well then that's fine too.

As to kvm-coco-queue, based on Yan's reply I have 1 (of course), 4 and
an extra patch to move kvm_x86_call(vm_destroy) at the very end of
kvm_arch_destroy_vm; I'll post everything as soon as I finish building
and testing.

Paolo

> rest are firmly 6.15 IMO.  And based on Yan's feedback, I'm planning on a=
dding a
> few more cleanups (though I think they're fully additive, i.e. can go on =
top).
>

