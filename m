From: Marc Zyngier <maz@misterjones.org>
Subject: Re: ARM32 guest on ARM64 host
Date: Sat, 25 Jun 2016 14:09:06 +0100
Message-ID: <3e90f50ac71c121f9421c702cb63a74f@www.loen.fr>
References: <f47a31f2-3f61-e2c7-a7c0-43dadd93b765@derytech.com.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D60849B4A
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Jun 2016 09:04:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Iqsr7Fnl-PtF for <kvmarm@lists.cs.columbia.edu>;
 Sat, 25 Jun 2016 09:04:06 -0400 (EDT)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 171BE49B1D
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Jun 2016 09:04:05 -0400 (EDT)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@misterjones.org>) id 1bGnKc-0005zh-Mq
 for kvmarm@lists.cs.columbia.edu; Sat, 25 Jun 2016 15:09:06 +0200
In-Reply-To: <f47a31f2-3f61-e2c7-a7c0-43dadd93b765@derytech.com.tw>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 2016-06-25 05:31, hiwu wrote:
> Hi all :
>
> 1) Can Arm64 Linux host enable KVM support for Arm32 guest ?

Yes, assuming your CPU does support AArch32 at EL1 (IOW is not 64bit 
only).

> 2) Can qemu-system-arm on Arm64 Linux host use the aarch32 KVM
> feature on Arm64 host ?

No. You need to use qemu-system-aarch64 and pass the "aarch64=off" 
option to the -mach directive.

         M.
-- 
Who you jivin' with that Cosmik Debris?
