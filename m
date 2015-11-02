From: Christopher Covington <cov@codeaurora.org>
Subject: Re: KVM/ARM: trap every load /store instruction
Date: Mon, 02 Nov 2015 13:36:27 -0500
Message-ID: <5637AD2B.9010609@codeaurora.org>
References: <1434718396-13110-1-git-send-email-marc.zyngier@arm.com>
 <1434718396-13110-6-git-send-email-marc.zyngier@arm.com>
 <559FD3D7.4030605@derytech.com.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BAD0B49708
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2015 13:33:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id npRVl-SY03Og for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Nov 2015 13:33:25 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 181E649444
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2015 13:33:21 -0500 (EST)
In-Reply-To: <559FD3D7.4030605@derytech.com.tw>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: hiwu <hiwu@derytech.com.tw>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 07/10/2015 10:16 AM, hiwu wrote:
> Hi:
> 
> Is it possible to trap every load /store instruction (ldr/str) on KVM/ARM ?

I'm still searching for an ideal solution, but from what I've read, it may be
more efficient to do this in userspace with a tool like valgrind
(`--tool=lackey --trace-mem=yes` might be a starting point) than a bunch of
hypervisor traps.

Christopher Covington

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
