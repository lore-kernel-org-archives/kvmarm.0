Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA6CFC433FE
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 17:53:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 026614B0D7;
	Thu,  3 Nov 2022 13:53:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WsRJXhsIXR7E; Thu,  3 Nov 2022 13:53:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E00914B105;
	Thu,  3 Nov 2022 13:53:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BDB64B0D0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 13:53:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GATZdjuBvqQf for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 13:53:37 -0400 (EDT)
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com
 [209.85.215.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1E1214B0CB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 13:53:37 -0400 (EDT)
Received: by mail-pg1-f171.google.com with SMTP id r18so2299844pgr.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 10:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=3tXwq1v6tJCedr2VtV8ELYd8BpIXTKwmGjuY8weIxs8=;
 b=gjqnoLy192oz/Zxvag+BlBreQGGSfkeJOmpmCEx7rtJpm2GzAgZsoDzOerCZhLAwiY
 s4s7ScvfoZl8zwg6HI1Ymb7QpOkn2NxzwKs5NTcMl1wbeFQ/hmv3VmCXwSollG4iohk8
 ZfCLF4UOQot0TZFoB2ZSgy0wzT2PFfm47J97NCOCE8O1C25eIzJzc1jTDAryWTakKtb6
 +QR4ykcFsYtONZVST62uH0g9I4NSfzwB8k/a9JLQz8I+tNs7JhVckzNuFRTBv1+mgFsk
 IdkM799qrsruF4xx+MeYDtb4Sd8Y4cxbHh++70LJo94wIuv8aLLKYeYlUVyl7mOC3bBK
 Ww4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=3tXwq1v6tJCedr2VtV8ELYd8BpIXTKwmGjuY8weIxs8=;
 b=uu+Bu2Izr6tD06LnXxS/b/nGnMBhzbqdR1Hjcg5JmTKmEpNX90/TjX9Tpf+NM3cWSX
 26+zYB0L5mCWDPOobQSZ0wgRMBtouWqp179XSiW59T4gwniNJ37MtEaBn+Jul2EoC2sm
 ZTfbzVi01HA0Lvx8iGo4Ih9ysNfPW1pohBLCMYT9EH7VDRcgmtld1E5gDUtk7pI5YvNO
 Ws4u46qtJSr9QAC1uQhSVXU74XnabAZnruAkYki7ErW+hoiuAyERmgIwyQomMoAs/GDF
 826LHc5seQ0Kh5WDDayhzFn4CsVaoyFTp4Amx2PR2Oyfoa0Rh9oGBw8izLpVF24ptwks
 8g9A==
X-Gm-Message-State: ACrzQf2/ldT9hjwBPdMi2taMahHBr8jhS+JlUya8YYrHTroJ8/n8eCpQ
 fC/8yxYzow8U1rpAJbOE9T9p1g==
X-Google-Smtp-Source: AMsMyM5pSkjZTiut6RFho0StQnuo7qAiklz26C63x768BJpOt4UV7sKT8fcspUYyR/B7P1xdFXKPhA==
X-Received: by 2002:a05:6a00:999:b0:56c:3d0d:96fe with SMTP id
 u25-20020a056a00099900b0056c3d0d96femr31657100pfg.12.1667498015565; 
 Thu, 03 Nov 2022 10:53:35 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 e20-20020a63e014000000b0045ff216a0casm1080329pgh.3.2022.11.03.10.53.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 03 Nov 2022 10:53:35 -0700 (PDT)
Date: Thu, 3 Nov 2022 17:53:31 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 39/44] KVM: Drop kvm_count_lock and instead protect
 kvm_usage_count with kvm_lock
Message-ID: <Y2QAG0wCPNv7atC/@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-40-seanjc@google.com>
 <7b6ce80e-7f1f-11cd-8bde-8d8fa9fd7e1d@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <7b6ce80e-7f1f-11cd-8bde-8d8fa9fd7e1d@redhat.com>
Cc: Matthew Rosato <mjrosato@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Yuan Yao <yuan.yao@intel.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, linux-kernel@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Chao Gao <chao.gao@intel.com>, Eric Farman <farman@linux.ibm.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org,
 Atish Patra <atishp@atishpatra.org>, kvmarm@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>, linuxppc-dev@lists.ozlabs.org
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

On Thu, Nov 03, 2022, Paolo Bonzini wrote:
> On 11/3/22 00:19, Sean Christopherson wrote:
> > +- kvm_lock is taken outside kvm->mmu_lock
> 
> Not surprising since one is a mutex and one is an rwlock. :)

Heh, 

  Signed-off-by: Captain Obvious <seanjc@google.com>

> You can drop this hunk as well as the "Opportunistically update KVM's locking
> documentation" sentence in the commit message.

Will do.

> >   - vcpu->mutex is taken outside kvm->arch.hyperv.hv_lock
> >   - kvm->arch.mmu_lock is an rwlock.  kvm->arch.tdp_mmu_pages_lock and
> > @@ -216,15 +220,11 @@ time it will be set using the Dirty tracking mechanism described above.
> >   :Type:		mutex
> >   :Arch:		any
> >   :Protects:	- vm_list
> > -
> > -``kvm_count_lock``
> > -^^^^^^^^^^^^^^^^^^
> > -
> > -:Type:		raw_spinlock_t
> > -:Arch:		any
> > -:Protects:	- hardware virtualization enable/disable
> > -:Comment:	'raw' because hardware enabling/disabling must be atomic /wrt
> > -		migration.
> > +		- kvm_usage_count
> > +		- hardware virtualization enable/disable
> > +		- module probing (x86 only)
> 
> What do you mean exactly by "module probing"?  Is it anything else than what
> is serialized by vendor_module_lock?

Ooh, I forgot to update this patch after switching to vendor_module_lock.  I
added the above after fixing the first deadlock between kvm_lock and cpu_hotplug_lock,
but later gave up on trying to use kvm_lock after deadlock #2, which is when I
when I realized piggybacking kvm_lock was going to be a maintainance nightmare due.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
