Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF60781720
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 00:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740529655; cv=none; b=gLtovlgTL3yNELvS9CHWtT8EqPgNjLUt9eCHN/K/0uLUmcmNlTEbKZ7BwPQB4Jam3QqFxPCdLnh5WmHSSz/gONJV10qO03i8Oz7Afq3VQnr63DF4pkBy32Y76vGHnIoMpSHAqD9+zhffrlg9g4uZy7WHeMVZFJ14Fde6hhmSObU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740529655; c=relaxed/simple;
	bh=YFdIcmETOAJxtDEb1Ht/Nh5ABrjaWCQRix/l3XIAYQ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=syA6tc9vzxkRkfYzg/NqVWhsJvCjPiY4l47aZbaxBwR9QPbLYpvil1BUURB0FP1J//7z5iyVWYSweLCM5hR0ysrmmZn6Hi4ylQI7AiAr8YN74vr6yhBf6XGttME5i7DJch6+Uwry9PnoLkZae00vhIKEkKW6TB9K3ACaCGnUMUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hQosHFu2; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hQosHFu2"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc2b258e82so13296465a91.0
        for <kvmarm@lists.linux.dev>; Tue, 25 Feb 2025 16:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740529653; x=1741134453; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HAdIv23vtdyhU1Wievr5YncZEjjI/nIoxYj3wcoEoAc=;
        b=hQosHFu2jXpepGL5Iyu28sT2esaoBnqpa99h5CzXwWQJfXw5uc5nEzk/W2CnAvPSJ7
         8O90ClYk9xQ/2Ut3DmroAJ8ntJ+m9YALbZNev2cCUhNxcGXcHAM+DdW8I9SR8AOQfif9
         4+vf5wSoRHLElSboL8lSO7JyOamm9LhY9yQD/Gd8TkT65ItW3q2DbLbO8vOCOF0BsfC+
         aCDrWIdRWuVJnQk6ySihAgD9vb3R2AXT2mJ3Qe3kGBcjTpXqht+WkRhDxNMRcZCOdbtr
         BguD4ff3W8TiNzzfxpf71+rYZDzu2N6Q9fK/YimQFVc1SOI81T8867PjCZFDCRYPe8sv
         t8lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740529653; x=1741134453;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HAdIv23vtdyhU1Wievr5YncZEjjI/nIoxYj3wcoEoAc=;
        b=e48+UOIEsWCIHcpwBjiePzqTQP6WxzH3I1CwaaEEzN3D7VaWxdwVlDlkEsBNRBBZ5j
         q8h9XyJxHe87ZR1eV00WVQEoOafR1BxohAqB2MTf4WMIlnD+s7ABH2hFEjXWPf8aTRFq
         rnhzMVzD8yK0noxVIKybdK2iquwre1GS8c4xNhXZ6f+kCmhLigJeOBFyZ8VmIjf4Xkq6
         VEG7yOILLup20pkC4FcfvoivkQq7F6G+g31EpnU9jj3vaKSTDRNRiilQPFEY80Eh87TT
         xfQuvgFyQfs4GcVvpILDqcrj2FV7r8qK7fKBlmm66P8hj6FNDAx6gKNOr/DHi6DJqk/1
         RQmA==
X-Forwarded-Encrypted: i=1; AJvYcCVjO07DIx64wzppYwLoxodYAw6sHo5FoxReL1T3O6kCd9E33Yn20RT03Xbo16DuO0W6mv0XLaE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzZP20gbiIRNmvPBxZ3wD7HvSAqwlpXqFC+UiQkaSbWObFOIA/f
	lyUKdvI9+Ym2Cx+nITZKq2nu0xDefnuB+p6HPavBIdbVbR7fKqihpAhHSOoWtyreLQzHkDPUqsn
	ERg==
X-Google-Smtp-Source: AGHT+IHOUZMQJO44VDHKi6ofhJ07QZ2dZ6izn0Wyr9X1ZaSMCJ5d0/qSAVcldTsRp+dWt1bBYLTGrWWvHEg=
X-Received: from pjbsb8.prod.google.com ([2002:a17:90b:50c8:b0:2d8:8340:8e46])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5483:b0:2ee:f076:20f1
 with SMTP id 98e67ed59e1d1-2fe7e218ab9mr2765842a91.0.1740529653271; Tue, 25
 Feb 2025 16:27:33 -0800 (PST)
Date: Tue, 25 Feb 2025 16:27:32 -0800
In-Reply-To: <6475f9c7-304a-4e0b-8000-3dc5c8e718e9@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250224235542.2562848-1-seanjc@google.com> <20250224235542.2562848-2-seanjc@google.com>
 <6475f9c7-304a-4e0b-8000-3dc5c8e718e9@redhat.com>
Message-ID: <Z75f9GuA9NfKo37c@google.com>
Subject: Re: [PATCH 1/7] KVM: x86: Free vCPUs before freeing VM state
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
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
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 26, 2025, Paolo Bonzini wrote:
> On 2/25/25 00:55, Sean Christopherson wrote:
> > Free vCPUs before freeing any VM state, as both SVM and VMX may access
> > VM state when "freeing" a vCPU that is currently "in" L2, i.e. that needs
> > to be kicked out of nested guest mode.
> > 
> > Commit 6fcee03df6a1 ("KVM: x86: avoid loading a vCPU after .vm_destroy was
> > called") partially fixed the issue, but for unknown reasons only moved the
> > MMU unloading before VM destruction.  Complete the change, and free all
> > vCPU state prior to destroying VM state, as nVMX accesses even more state
> > than nSVM.
> 
> I applied this to kvm-coco-queue, I will place it in kvm/master too unless
> you shout.

Depends on what "this" is :-)

My plan/hope is to land patches 1 and 2 in 6.14, i.e. in kvm/master, but the
rest are firmly 6.15 IMO.  And based on Yan's feedback, I'm planning on adding a
few more cleanups (though I think they're fully additive, i.e. can go on top).
