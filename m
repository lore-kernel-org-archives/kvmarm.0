Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C622C3DA7A
	for <kvmarm@archiver.kernel.org>; Wed, 28 Dec 2022 11:22:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D4DA94B81C;
	Wed, 28 Dec 2022 06:22:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PmDr4tvBQ9P6; Wed, 28 Dec 2022 06:22:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D55C74B835;
	Wed, 28 Dec 2022 06:22:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FFCC4B81C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Dec 2022 06:22:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EAugmy4TajFb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Dec 2022 06:22:15 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC38E4B803
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Dec 2022 06:22:15 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 1D2C46136E;
 Wed, 28 Dec 2022 11:22:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C988C433EF;
 Wed, 28 Dec 2022 11:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1672226533;
 bh=g/ko60RCUy62mgwJX+BHqh4+FybNochgcGqfnbFgn1s=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=bkySoNrEPygYgl5QF2mbRvdQP90/TfV81MHuS96aaZXlQcngUJ3MnPH6eA7QDx4Th
 9qys9DmCGwyeY+hU2x+2CaIsq4ffMaWs2Andkc5MUnCRyhe2gJL1UT52VEPs78jq5D
 4F1Tuo0nQj1sMGDBh/MID5iNoErPu3cmtJOLrAi9mragNuaOC3UExlhvrMtXFgnRzt
 wrjQrwIdzHmXG2C/xHTzuK1MlUOE4h7gPaZmWOD7ADqmpxfpX3FjjQu/1lKSa6NQ2/
 OpnrZhXA+oWI8B3m33i+IQsklsKqkL22FNLezHwLuMeZmbP3lDV+wqKLg9C8uYzdJ+
 KTTyjywJXPOvw==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1pAUVf-00FXTE-4f;
 Wed, 28 Dec 2022 11:22:11 +0000
MIME-Version: 1.0
Date: Wed, 28 Dec 2022 11:22:10 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 00/50] KVM: Rework kvm_init() and hardware enabling
In-Reply-To: <20221227130249.1650197-1-pbonzini@redhat.com>
References: <20221227130249.1650197-1-pbonzini@redhat.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <9acea262dec3511e9cf63081506f0bd7@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, seanjc@google.com,
 chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com, anup@brainfault.org,
 paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
 borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
 mjrosato@linux.ibm.com, farman@linux.ibm.com, vkuznets@redhat.com,
 dwmw2@infradead.org, paul@xen.org, james.morse@arm.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev,
 atishp@atishpatra.org, david@redhat.com, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, yuan.yao@intel.com, cohuck@redhat.com,
 isaku.yamahata@intel.com, philmd@linaro.org, farosas@linux.ibm.com,
 mpe@ellerman.id.au, kai.huang@intel.com, chao.gao@intel.com,
 tglx@linutronix.de
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Matthew Rosato <mjrosato@linux.ibm.com>, Paul Durrant <paul@xen.org>,
 Yuan Yao <yuan.yao@intel.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Kai Huang <kai.huang@intel.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Chao Gao <chao.gao@intel.com>, Eric Farman <farman@linux.ibm.com>,
 Albert Ou <aou@eecs.berkeley.edu>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, Atish Patra <atishp@atishpatra.org>,
 kvmarm@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
 linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Fabiano Rosas <farosas@linux.ibm.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, Palmer Dabbelt <palmer@dabbelt.com>,
 kvm-riscv@lists.infradead.org, Michael Ellerman <mpe@ellerman.id.au>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, David Woodhouse <dwmw2@infradead.org>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2022-12-27 13:02, Paolo Bonzini wrote:
> Queued, thanks.  I will leave this in kvm/queue after testing 
> everything
> else and moving it to kvm/next; this way, we can wait for test results
> on other architectures.

Can you please make this a topic branch, and if possible based
on a released -rc? It would make it a lot easier for everyone.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
