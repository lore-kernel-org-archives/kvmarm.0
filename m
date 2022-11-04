Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 728EDC4332F
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 20:27:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDF4440E76;
	Fri,  4 Nov 2022 16:27:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id j5Isg+SUtogQ; Fri,  4 Nov 2022 16:27:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A7CFA40F59;
	Fri,  4 Nov 2022 16:27:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1236540E76
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 16:27:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Mfl9w-CgIv8x for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2022 16:27:20 -0400 (EDT)
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com
 [209.85.210.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0751540E71
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 16:27:19 -0400 (EDT)
Received: by mail-pf1-f177.google.com with SMTP id q9so5464862pfg.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Nov 2022 13:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=TzyhTv3BAtgpGpRr8HnNLx/d2zCvSqkboAFtik4Imo0=;
 b=q/PTXKQj3ArVm2XzZe97QeFygVMm1eXh+9AVtXcJ75aOhS7rpOmmmorCukrcxmTsXJ
 xtHpP7JyICLKwJpO4UdyBCOfADg9j8qWzQtBsGyOUBj4dtUE2hEcaa0M2lJNL2RYHNdm
 t9CE40syL4mSgI+9axRmHRY3m49U53Bcc5xsUL4w5HmCnvq3rZFCi8RspoeZ0S4Nhg0P
 dklWYN0e+iqclhNFPVLNqLlrIm4bRgIuUSiy6nVFx0aKBZbtXqUzzmm+oTu43A9TiINS
 r9mhyi03/1kAIfHUOzdEnLew/bMGSFKH13ZsSBoEdZkxO+PvUKRhjXGV6DaJ6ZELthJK
 tWVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=TzyhTv3BAtgpGpRr8HnNLx/d2zCvSqkboAFtik4Imo0=;
 b=cHUxFoFUqLfw5ueLFDCYdmpuD+3qIe5NkDoIeCq00G9C2hAJmdNakq2qrE1e3saRpo
 7BBDlb4yGkZQTY0cL0GHnTFw82+9u5ax2GDf68RaRz+9Lcvi81RjQ/mCk79IIhJ4/jpB
 VQ2ca9VGs/XIsykTcRSMpIkXIbPuSsOhDQ4f573V/A/J/jAae/2DGylFhr2HSpBqaEqa
 C2W1krV+oaGkzkIAAzQ4Pa2WjzRb2U9KO8uRQV4PMbUahJPCSH4gNHG3Gcolvu1g4XvJ
 +a8kIi3IkeH338APs8crr4jP8l3v/kmaDVIPUVRsf+opT2wccgtByqKKBAQoV+6m+7OF
 11sg==
X-Gm-Message-State: ACrzQf3XQmtBoIaizwfwhP/WkAokHbIqDXl/HBMsL0q0AL6EgjVhsFDd
 N9IOO+2MuTSss48EB+0YazdTag==
X-Google-Smtp-Source: AMsMyM6nILnCIcSIsk5JMrE+WRVnxFnaYDn7QGx3yWf1KAa3dZc7TNSn3aZcg19Xay3NbhiF32a9mw==
X-Received: by 2002:a05:6a00:1781:b0:561:7f7f:dc38 with SMTP id
 s1-20020a056a00178100b005617f7fdc38mr38037687pfg.42.1667593638927; 
 Fri, 04 Nov 2022 13:27:18 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 u8-20020a1709026e0800b0018863e1bd3csm159522plk.134.2022.11.04.13.27.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 04 Nov 2022 13:27:18 -0700 (PDT)
Date: Fri, 4 Nov 2022 20:27:14 +0000
From: Sean Christopherson <seanjc@google.com>
To: Isaku Yamahata <isaku.yamahata@gmail.com>
Subject: Re: [PATCH 00/44] KVM: Rework kvm_init() and hardware enabling
Message-ID: <Y2V1oslbw24/2Opd@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221104071749.GC1063309@ls.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221104071749.GC1063309@ls.amr.corp.intel.com>
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
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 linuxppc-dev@lists.ozlabs.org
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

On Fri, Nov 04, 2022, Isaku Yamahata wrote:
> Thanks for the patch series. I the rebased TDX KVM patch series and it worked.
> Since cpu offline needs to be rejected in some cases(To keep at least one cpu
> on a package), arch hook for cpu offline is needed.

I hate to bring this up because I doubt there's a real use case for SUSPEND with
TDX, but the CPU offline path isn't just for true offlining of CPUs.  When the
system enters SUSPEND, only the initiating CPU goes through kvm_suspend()+kvm_resume(),
all responding CPUs go through CPU offline+online.  I.e. disallowing all CPUs from
going "offline" will prevent suspending the system.

I don't see anything in the TDX series or the specs that suggests suspend+resume
is disallowed when TDX is enabled, so blocking that seems just as wrong as
preventing software from soft-offlining CPUs.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
