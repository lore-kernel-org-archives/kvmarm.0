Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C7A9C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  4 May 2022 06:43:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4D7D4B176;
	Wed,  4 May 2022 02:43:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@quicinc.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ENBm302vKzeX; Wed,  4 May 2022 02:43:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C54A04B105;
	Wed,  4 May 2022 02:43:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFD2E4B17D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 18:23:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K2Hg+qRppPy2 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2022 18:23:46 -0400 (EDT)
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com
 [199.106.114.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 856F649EBE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 18:23:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
 t=1651616626; x=1683152626;
 h=date:from:to:cc:subject:message-id:references:
 mime-version:in-reply-to;
 bh=xnDs4fqABVmtbO8EfV302QSHZqoqwEJa0N8z1KcZxsw=;
 b=DOxD/Ncvqoz7tGGtrjLJQH6z6ruXNW2hI2MqRfE6lkml3/eqIRwSpDCa
 2cf8gqsb+BHgPUxxyg0msb17Wj1I8vlTCODFqlRKsjq28D187fhhvYBy7
 OnzqPrXkYRidz0fB9XrLSPqU4Kh4pCc2UW04hxKR0eE0C2I8uGI2jRAs7 0=;
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
 by alexa-out-sd-02.qualcomm.com with ESMTP; 03 May 2022 15:23:45 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
 by ironmsg-SD-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 03 May 2022 15:23:45 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 3 May 2022 15:23:44 -0700
Received: from qian (10.80.80.8) by nalasex01a.na.qualcomm.com (10.47.209.196)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 3 May 2022
 15:23:42 -0700
Date: Tue, 3 May 2022 18:23:40 -0400
From: Qian Cai <quic_qiancai@quicinc.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v14 00/39] arm64/sme: Initial support for the Scalable
 Matrix Extension
Message-ID: <YnGrbEt3oBBTly7u@qian>
References: <20220419112247.711548-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220419112247.711548-1-broonie@kernel.org>
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Mailman-Approved-At: Wed, 04 May 2022 02:43:28 -0400
Cc: Marc Zyngier <maz@kernel.org>,
 Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alan Hayward <alan.hayward@arm.com>,
 Salil Akerkar <Salil.Akerkar@arm.com>, linux-kselftest@vger.kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>, Shuah
 Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Luca Salabrino <luca.scalabrino@arm.com>
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

On Tue, Apr 19, 2022 at 12:22:08PM +0100, Mark Brown wrote:
> This series provides initial support for the ARMv9 Scalable Matrix
> Extension (SME).  SME takes the approach used for vectors in SVE and
> extends this to provide architectural support for matrix operations.  A
> more detailed overview can be found in [1].

Set CONFIG_ARM64_SME=n fixed a warning while running libhugetlbfs tests.

        /*
         * There are several places where we assume that the order value is sane
         * so bail out early if the request is out of bound.
         */
        if (unlikely(order >= MAX_ORDER)) {
                WARN_ON_ONCE(!(gfp & __GFP_NOWARN));
                return NULL;
        }

 WARNING: CPU: 122 PID: 4025 at mm/page_alloc.c:5383 __alloc_pages
 CPU: 122 PID: 4025 Comm: brk_near_huge Not tainted 5.18.0-rc5-next-20220503 #79
 pstate: 20400009 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 pc : __alloc_pages
 lr : alloc_pages
 sp : ffff8000505470f0
 x29: ffff8000505470f0 x28: ffff40028b3535c0 x27: 0000000000000000
 x26: 1ffff0000a0a8ea2 x25: ffff800050547510 x24: 0000000000000dc0
 x23: ffff921ddb818000 x22: 000000000000000e x21: 1ffff0000a0a8e28
 x20: 0000000000040dc0 x19: ffffae1848c61ae0 x18: ffffae18357e7d24
 x17: ffffae182fb75778 x16: 1fffe8005166a7d8 x15: 000000000000001a
 x14: 1fffe8005166a7cb x13: 0000000000000004 x12: ffff70000a0a8e03
 x11: 1ffff0000a0a8e02 x10: 00000000f204f1f1 x9 : 000000000000f204
 x8 : dfff800000000000 x7 : 00000000f3000000 x6 : 00000000f3f3f3f3
 x5 : ffff70000a0a8e28 x4 : ffff40028b3535c0 x3 : 0000000000000000
 x2 : 0000000000000001 x1 : 0000000000000001 x0 : 0000000000040dc0
 Call trace:
  __alloc_pages
  alloc_pages
  kmalloc_order
  kmalloc_order_trace
  __kmalloc
  __regset_get
  regset_get_alloc
  fill_thread_core_info
  fill_note_info
  elf_core_dump
  do_coredump
  get_signal
  do_signal
  do_notify_resume
  el0_svc
  el0t_64_sync_handler
  el0t_64_sync
 irq event stamp: 28066
 hardirqs last  enabled at (28065):  _raw_spin_unlock_irqrestore
 hardirqs last disabled at (28066):  el1_dbg
 softirqs last  enabled at (27438):  fpsimd_preserve_current_state
 softirqs last disabled at (27436):  fpsimd_preserve_current_state
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
