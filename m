Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12E76C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 19 Jul 2022 14:24:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 839924CE2D;
	Tue, 19 Jul 2022 10:24:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fLLRh5nwd9Cx; Tue, 19 Jul 2022 10:24:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 659744CE51;
	Tue, 19 Jul 2022 10:24:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F5AB4CE2F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 10:24:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P8TtM+Be8jak for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Jul 2022 10:24:20 -0400 (EDT)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com
 [209.85.221.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C7B0C4CE2D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 10:24:20 -0400 (EDT)
Received: by mail-wr1-f44.google.com with SMTP id bu1so21827195wrb.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 07:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=WNzGE1u5XBqK6Mb53sKBN5FU4Tw9+8CwrSdfuz5XdPs=;
 b=bfJEy/cnbMf7Dd+3HUkkFGC74hUVFhvhiX6RtKyPK1wNJDjzvZWDt9+QS+wz40FrTN
 HztEGcPqJAgSYKG5Ud5mP6WUgE5Vsy1Ey8x4vwxGGzkErc+F/f4zZMXKV0W4AoLMIYlK
 rdK+I8odxO/LtKbwOdwbk6RtcEFXy0MMU564JRUEqezINa/PYfR4wFoBfsx6h291tdla
 2u52mftckZzlk3NyzHKaePzs+dBYbx4O1KOBoQc6OldLHSFib9f4w0hUX9pjQsZ2PO21
 3eHZvRyOltIeXzszeKsuuBmjOvDQD9I5sMAE3gYJJv6Epw3/x+G4XvUt9Ds5GsvWij9u
 3y9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=WNzGE1u5XBqK6Mb53sKBN5FU4Tw9+8CwrSdfuz5XdPs=;
 b=KuIPZ7Lu2ZN3fyAnx8dFHNKvgdNVyc3SyVqy/KXqnbWX/vLpDAsnhrAB0BVFu6W6xW
 Svy4bCWFvtJeVv+UhD/Fj2hPiPxfBAH2MHXtlpoYB5jR8ZfvAxwh0bT5s8X05rkK/4im
 DvS0bdwkJhYZaXKvx/dy0dsxReoW5VUSymKBCezZkMtpDMFDZ0VKL9gQteREiKitiS3j
 nk9fdAUxX1HjE/et8AU20lQppoA3GmBo2Z7gyddUVCs+Cn41jSy4NzUP9KQto/Ask+9k
 5DyAEHuZ7loP9pnAX5nCmZDGVn8hHg9z8KsdXpj++p3upoEs2hv7ijmeL0IXwfllX5S0
 IrnQ==
X-Gm-Message-State: AJIora+pPZ3e2QjGrmmbH8NKQYw60KLgI3cnf3dvLpBJQJfSY/9nnO5z
 5+stgB/HjVlQxUl/EV874YpywA==
X-Google-Smtp-Source: AGRyM1u/zzb8ihXo42fNXAW1OoFznD0EcxAfeIq6ZlSo4Z+it7CYm8RtVz9+EnpyHMxpc1irG479Bw==
X-Received: by 2002:a5d:6d8f:0:b0:21d:b7d0:a913 with SMTP id
 l15-20020a5d6d8f000000b0021db7d0a913mr26582401wrs.462.1658240659597; 
 Tue, 19 Jul 2022 07:24:19 -0700 (PDT)
Received: from google.com (109.36.187.35.bc.googleusercontent.com.
 [35.187.36.109]) by smtp.gmail.com with ESMTPSA id
 e9-20020a05600c4e4900b0039c811077d3sm19310285wmq.22.2022.07.19.07.24.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 19 Jul 2022 07:24:19 -0700 (PDT)
Date: Tue, 19 Jul 2022 15:24:15 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 00/24] KVM: arm64: Introduce pKVM shadow state at EL2
Message-ID: <Yta+jyw9MfYQPC+e@google.com>
References: <20220630135747.26983-1-will@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220630135747.26983-1-will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Oliver Upton <oliver.upton@linux.dev>, Andy Lutomirski <luto@amacapital.net>,
 linux-arm-kernel@lists.infradead.org, Michael Roth <michael.roth@amd.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Jun 30, 2022 at 02:57:23PM +0100, Will Deacon wrote:
> Hi everyone,
> 
> This series has been extracted from the pKVM base support series (aka
> "pKVM mega-patch") previously posted here:
> 
>   https://lore.kernel.org/kvmarm/20220519134204.5379-1-will@kernel.org/
> 
> Unlike that more comprehensive series, this one is fairly fundamental
> and does not introduce any new ABI commitments, leaving questions
> involving the management of guest private memory and the creation of
> protected VMs for future work. Instead, this series extends the pKVM EL2
> code so that it can dynamically instantiate and manage VM shadow
> structures without the host being able to access them directly. These
> shadow structures consist of a shadow VM, a set of shadow vCPUs and the
> stage-2 page-table and the pages used to hold them are returned to the
> host when the VM is destroyed.
> 
> The last patch is marked as RFC because, although it plumbs in the
> shadow state, it is woefully inefficient and copies to/from the host
> state on every vCPU run. Without the last patch, the new structures are
> unused but we move considerably closer to isolating guests from the
> host.
> 
> The series is based on Marc's rework of the flags
> (kvm-arm64/burn-the-flags).
> 
> Feedback welcome.
> 
> Cheers,

Only had few nitpicks

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

Also, I've been using this patchset for quite a while now.

Tested-by: Vincent Donnefort <vdonnefort@google.com>

[...]
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
