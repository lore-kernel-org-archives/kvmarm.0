Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83790C4708E
	for <kvmarm@archiver.kernel.org>; Fri,  2 Dec 2022 16:08:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F0A76402ED;
	Fri,  2 Dec 2022 11:08:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ehp1HJwXlnct; Fri,  2 Dec 2022 11:08:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7170411C7;
	Fri,  2 Dec 2022 11:08:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E13E4402ED
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2022 11:08:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lCxRFH7bozsI for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Dec 2022 11:08:10 -0500 (EST)
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com
 [209.85.210.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8D9AA40298
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2022 11:08:10 -0500 (EST)
Received: by mail-pf1-f173.google.com with SMTP id w129so5304947pfb.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 02 Dec 2022 08:08:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=LMdFvNSIKdTJxppFI5JflU3ZXHxkZjSJ4fG5U4tk7Tk=;
 b=kw0qyCOMp2u+ojev0wrASw/lF7r9rOnRJHqLy08FIIr+f+qpPtSFohe59bJmaOi/rJ
 xcGzBwmHctfDCuY/HsZstsw01nTTKqB9D0ItsIVCZBuDkF6U4LFd8/XxyiMZ9HQQBawu
 5Br6kbHRMEkmhVdkrdlpAnXBg7aXr8x1ngEkT987D0vDq9wJ1LYSA7pyGWl0PB6S36YX
 Ye0BXjX/JFQwCFB0idj1kNjBh1WOFf2yIueArh18nn+f3Kk6RhG95XRHvHGlIJTCnyAw
 T+Hf0HOA9lpO63L3167YfTmLHua9wbiTHz1XwCqkS0us3SdkuoK9a/bX1aNd1tZdIG9m
 GSrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=LMdFvNSIKdTJxppFI5JflU3ZXHxkZjSJ4fG5U4tk7Tk=;
 b=Ku1vW7zYr6eWT0MSAJliNr6jxu//m2Ys6KaRNkyGRZT7wfyAAqhXJiRz10hAmoTey4
 4KFZxodNpGa2CfkZ/QDce7pZ39GF1L6JtmbRRubr03XRDGh2RS+rYr9Rwx1wvdXcFh5Q
 cqLa0kCKcrWumxEKpbRVK0joAEjABoYfxV+KelAJs0bCNdSHHsf0PuXLriK1O/4qwslH
 QBlpiwPTjINaipDXchx5HB04wij1r+4gv1GXUZ9ZdT+v9pV5Lbno7z/UKWR2MobdcXFp
 0Qythbvt5OygwdvPMR0PLNyP40gyPo17K09nzIDBqmrVFS6Ro/9YavS59w+ZDtAU2fLA
 LG2A==
X-Gm-Message-State: ANoB5plbaKA0XLTyKuyuSHRjTLyGL8LKYiaRj8SPk0KY3rj60n2h96N9
 Q0f4piyvSrdYttl6FOuM6df3bA==
X-Google-Smtp-Source: AA0mqf5a5KU+HXt1yCJ0zhlFtswkW2r0VasQIXpEBIwwE2hKQw/T3gXBywz5nj+1M/Ux52wSBF1P1g==
X-Received: by 2002:a63:495e:0:b0:470:75a1:c6d7 with SMTP id
 y30-20020a63495e000000b0047075a1c6d7mr47336241pgk.120.1669997286584; 
 Fri, 02 Dec 2022 08:08:06 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 w23-20020a1709026f1700b00189667acf19sm5714233plk.95.2022.12.02.08.08.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 02 Dec 2022 08:08:06 -0800 (PST)
Date: Fri, 2 Dec 2022 16:08:02 +0000
From: Sean Christopherson <seanjc@google.com>
To: "Huang, Kai" <kai.huang@intel.com>
Subject: Re: [PATCH v2 41/50] KVM: Rename and move CPUHP_AP_KVM_STARTING to
 ONLINE section
Message-ID: <Y4oi4oRk7jsCqYJO@google.com>
References: <20221130230934.1014142-1-seanjc@google.com>
 <20221130230934.1014142-42-seanjc@google.com>
 <c74c88ba6a17da2d36e2d340ce22af127bda8383.camel@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <c74c88ba6a17da2d36e2d340ce22af127bda8383.camel@intel.com>
Cc: "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
 "paul@xen.org" <paul@xen.org>, "Yao, Yuan" <yuan.yao@intel.com>,
 "david@redhat.com" <david@redhat.com>,
 "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
 "atishp@atishpatra.org" <atishp@atishpatra.org>,
 "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
 "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
 "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
 "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
 "maz@kernel.org" <maz@kernel.org>,
 "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
 "aleksandar.qemu.devel@gmail.com" <aleksandar.qemu.devel@gmail.com>,
 "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "Gao,
 Chao" <chao.gao@intel.com>, "farman@linux.ibm.com" <farman@linux.ibm.com>,
 "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "philmd@linaro.org" <philmd@linaro.org>,
 "farosas@linux.ibm.com" <farosas@linux.ibm.com>,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "palmer@dabbelt.com" <palmer@dabbelt.com>,
 "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "vkuznets@redhat.com" <vkuznets@redhat.com>,
 "dwmw2@infradead.org" <dwmw2@infradead.org>
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

On Fri, Dec 02, 2022, Huang, Kai wrote:
> On Wed, 2022-11-30 at 23:09 +0000, Sean Christopherson wrote:
> > From: Chao Gao <chao.gao@intel.com>
> > 
> ...
> 
> > 
> > Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: Chao Gao <chao.gao@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Perhaps I am wrong, but I have memory that if someone has SoB but isn't the
> original author should also have a Co-developed-by?

This is the case where a patched is passed along as-is, e.g. same as when
maintainers apply a patch.  Isaku posted Chao's patch, and then I came along and
grabbed the patch that Isaku posted.  I could go back and grab Chao's patch
directly, but Yuan's review was provided for the version Isaku posted, so I
grabbed that version.

> > Reviewed-by: Yuan Yao <yuan.yao@intel.com>
> > [sean: drop WARN that IRQs are disabled]
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
