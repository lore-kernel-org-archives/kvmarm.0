Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C532FD7D6
	for <kvmarm@lists.linux.dev>; Fri, 31 Oct 2025 17:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761930725; cv=none; b=VzWtV0N1h5jvgJF5ZkMuOrThU13sJ2Z+4KCqiCdVMzTxdF3X32JhYk5z4CcvIECbp+vAYtP7QClxyWbX6CLC7qJIozFyjXQXSJaxYR2407iM9NMDK41zZ5ol2rGcEEOMJYZPgbk4vWT+xAZ23ChDFg5UcSaGDDw/JURZU2CP+Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761930725; c=relaxed/simple;
	bh=2Py81n9yIbaq9LVne2Z6xEysNPQOVrfItEqxp5YA7aE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QB21nf9sCsfPBnz3boc+yupoG2ZrqaeRCG5jVZ1XA6Gm3DLz1WhhG3kl/vqlYcH7Qcy78g3YDAvdFcJIVZYDeOI5pA2ua58cC8gu5niYmWtYlBk/VNdUlA6wgWeY1aTanFjvuTc/8KsKllIGzpSQWR53iC0RVbdmHeDe2rVoSL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sHDU/8JR; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sHDU/8JR"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34082c48b2bso1541850a91.1
        for <kvmarm@lists.linux.dev>; Fri, 31 Oct 2025 10:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761930723; x=1762535523; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HjXjY8ls4xQvqV6pquPYuHe7QqNVj5FW0YEflavTuCM=;
        b=sHDU/8JRRjU8crK8EZBgCp/Purmdputee6iKZSKOEkPaJlVQVksZYRnrOgjX1P/3VZ
         u9ACChdjQXdDMHGdFD/E/91Wcpf74VTdffhc8VpXAS7McjCGIHDbAw0mM43g7ILmhXXD
         RuZ5iFHy0HUX6NCXHoJMcre2MCpzPX7cVTR3XLx1Hx0Kje6Ir8/3VoafpfO9edYgCqyF
         pl8NcFUF8ZHw8FhuI55tOAH1mnzyIUpfq11ccUQ8SMn9r1az73JEEbLYRvMXec6ocbhd
         RO7tIAMhM5zTLPZ5u+bf47qAPlzBokZQVUmWpL3aKMhMwAYWru8ALgfYQa5gXFDTXYHc
         Cw+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761930723; x=1762535523;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HjXjY8ls4xQvqV6pquPYuHe7QqNVj5FW0YEflavTuCM=;
        b=NL671f0lLl8MMnTESo8yhl93MUgt5Whg/H7iQObMb5yu305JD6smFfcV1YNYTAnmXK
         1tcMN9dUseDnzaSYtYfK2Dlm+oKc4dBbYdI/A1/03gtErEvqh98IoEEteEQyHd8/RvLR
         AJ9fFMGCjBex8M4/A57ismPS+jU2Z6+Mt2/E4QSNJzCqTelhR2343AgzgoPwzg7YPWww
         /IicGvqdkLrljdpoAOGikRZtfkqJfMMUzMsQa/594Yy+3pjRFqV0jugpvMBG9ezV7yjX
         M8TsQB2AYbQVUYn97fx1q/0laqoorrfpRmSmenorm4oh4VpEcl3SQ9Clqf4o7cLR92vU
         6B3g==
X-Forwarded-Encrypted: i=1; AJvYcCWZpQY46d/jhZVNOlngzDYzWnZ/70FHWVga0U+8Vixr4DBxiXAovRYjYnUJmhs8WgeCN20Wymo=@lists.linux.dev
X-Gm-Message-State: AOJu0YyDN6yb5bH5vQqizRXBu1eQ82qllaP5JMIap0UsaZvj7yvxxhg1
	iCYZPmgfQS9ltOImlBZGZ+gd21zG325F3r3knNNaCJvUvWJ0t8yYMX8Pd6nEKYujGCDs2kkikHB
	jBoR00Q==
X-Google-Smtp-Source: AGHT+IGfSgMUQo+5u2P6PetuRGaKK3ywl60OSkXvDDKeMxjcSsBTGVvS+p3TiopL8XWw5d9McqxPGzj/wX4=
X-Received: from pjbsr13.prod.google.com ([2002:a17:90b:4e8d:b0:340:b55d:7a07])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:388d:b0:32e:d599:1f66
 with SMTP id 98e67ed59e1d1-34083089300mr5226937a91.30.1761930723259; Fri, 31
 Oct 2025 10:12:03 -0700 (PDT)
Date: Fri, 31 Oct 2025 10:12:01 -0700
In-Reply-To: <aQRzWb3Fu6ywdE9t@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251030200951.3402865-1-seanjc@google.com> <20251030200951.3402865-9-seanjc@google.com>
 <aQRzWb3Fu6ywdE9t@yzhao56-desk.sh.intel.com>
Message-ID: <aQTt4R4CflSuVnCX@google.com>
Subject: Re: [PATCH v4 08/28] KVM: TDX: Drop superfluous page pinning in S-EPT management
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	x86@kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Michael Roth <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 31, 2025, Yan Zhao wrote:
> >   - Increasing the folio reference count only upon S-EPT zapping failure[5].
> Nit: There's a warning:
> 
> WARNING: Prefer a maximum 75 chars per line (possible unwrapped commit description?)

Checkpatch is a (very helpful) tool, but it is not authoritative in any way.
Similar to the how "wrap at 80 chars" is a soft rule that can and should be
broken depending on context, checkpatch should also be ignored for things like
this.  If someone says that the period making the line "too long" actually makes
this unreadable for them, then they're just trolling at that point :-)
