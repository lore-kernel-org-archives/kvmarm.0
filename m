Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7405CA55
	for <kvmarm@lists.linux.dev>; Fri,  4 Aug 2023 18:33:55 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d07cb52a768so2564816276.1
        for <kvmarm@lists.linux.dev>; Fri, 04 Aug 2023 11:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691174034; x=1691778834;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SzgCQZrREJ8wwDiX6siz2qHa1/7eISD6QAlgSdu5Knw=;
        b=dafKDsAUIw0Ie3fHqOzQMKvbKji+TOslqxd+53S8Ae1ULDmkeB/ua1YPOdYXPbSr0W
         n0B0znsGS31LPviJM1SZCFmESkuTcUMny2hya9DL0xdvpWCSxSHRJCfVCbNxLfYyeFRv
         EIycdVeNgQRE7OZLu04A+9r6jEyZbrSMa/ojO+QiKtGQ5lFCv7kKrPSc1rHckvDKMSWE
         Py9HduHTpVfSHRrXxUOhd0+x82M2xiEsF5OLWY4E2sB+9UWBaFq9En3wnmE643RVcCta
         tFFvd4rXgtsTJi80YNeW/3oG4StJ9Y06uzrmvVFVFIhnYu0yb5aHuCS39qa1aL/NYiUV
         FCOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691174034; x=1691778834;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SzgCQZrREJ8wwDiX6siz2qHa1/7eISD6QAlgSdu5Knw=;
        b=IC6iVMxVE+S0Ok5RvlXRlDNSZPScze7YpYuzXyh71ZsFppNch1lIddvTsfYXhOcxhD
         /Qj2ZJqQgnB0z4k9neLLzjW/1yNqAtRLwkZas2PuDNTRN8aI0ZpWFvzI+qVkIyrVi5VL
         IK0Wj/9zmILf69ea/oX13Sw/vZNIPdTUsBJqlZCmyJ9fowh6Dm3UNckDrMhTHNidZx1J
         zlCUXFeMgvGJ70QWE3CAIc/AAUHze3Ax97O2j1EWinDM0Qmo8XLi0+2kb3xOcx7/DSmQ
         x95/XWiUUM9sTi0Fpe+xCCmNqUoTDDda/liI2vvEY4xKS0Tf4JVUmqEc3Bpe5tlzOjTP
         ikHw==
X-Gm-Message-State: AOJu0Yy1XHNPmPGXKC2DCkYZZ8KzCB61E22i7WBgQPFu9Vr9G7HhLpEV
	T584uayvBEPNrRtBbgXH7CuRe83uTiY=
X-Google-Smtp-Source: AGHT+IEu3d94rrVmJ78RS29lOywQDiyzD14VCrwEVoVIDv3RxrRH95F0M9gwGQrPVV9YwLdxoui14M8wTbI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:42ca:0:b0:d07:16db:6f8f with SMTP id
 p193-20020a2542ca000000b00d0716db6f8fmr13913yba.6.1691174034726; Fri, 04 Aug
 2023 11:33:54 -0700 (PDT)
Date: Fri, 4 Aug 2023 11:33:53 -0700
In-Reply-To: <gsnto7jm8zbu.fsf@coltonlewis-kvm.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <ZM0rXgKvb912k5BE@linux.dev> <gsnto7jm8zbu.fsf@coltonlewis-kvm.c.googlers.com>
Message-ID: <ZM1EkRMf23e2YUBs@google.com>
Subject: Re: [PATCH 2/4] KVM: selftests: Add helper macros for ioctl()s that
 return file descriptors
From: Sean Christopherson <seanjc@google.com>
To: Colton Lewis <coltonlewis@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, maz@kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, mhal@rbox.co
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 04, 2023, Colton Lewis wrote:
> Oliver Upton <oliver.upton@linux.dev> writes:
> 
> > Hi Sean,
> 
> > On Thu, Aug 03, 2023 at 05:42:24PM -0700, Sean Christopherson wrote:
> > > Add KVM, VM, and vCPU scoped helpers for ioctl()s that return file
> > > descriptors, i.e. deduplicate code for asserting success on ioctls() for
> > > which a positive return value, not just zero, is considered success.
> 
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> > I appreciate the desire to eliminate duplicate code, but I think the
> > naming just muddies the waters. TBH, when I first read the diff w/o the
> > changelog, I thought you were describing the input fd (i.e. 'kvm_fd',
> > 'vm_fd', 'vcpu_fd'). I don't think explicitly spelling out the condition
> > each time (i.e. ret >= 0) is all that difficult.
> 
> Couldn't ret >= 0 be the assert condition for everything? Don't see why
> there needs to be different helpers to check == 0 and >= 0.
> 
> Unless I'm missing something, error returns are only ever negative.

Using "ret >= 0" would work in the sense that the tests wouldn't fail, but it
would degrade our test coverage, e.g. selftests wouldn't detect KVM bugs where
an ioctl() unexpectedly returns a non-zero, positive value.

The other wrinkle is that selftests need to actually consume the return value for
ioctl()s that return a positive value, i.e. the fd (or whatever it is) needs to
propagated up the stack.  I.e. all of the generic ioctl() macros would need to
"return" the value, which I really don't want to do because that would (re)open
the gates for having helpers that return an int, even though the only possible
return value is '0'.
