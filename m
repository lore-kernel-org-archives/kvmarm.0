From: Itaru Kitayama <itaru.kitayama@riken.jp>
Subject: Re: [PATCH] KVM: arm64: Check GICV address is placed at a 4Kb boundary
Date: Thu, 30 Jun 2016 12:23:17 +0900
Message-ID: <7fc8cf5d-0df2-f585-9384-9282f58287a2@riken.jp>
References: <cb18ab2d-12d9-bdd2-8432-801af488e340@riken.jp>
 <20160629124342.GV26498@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0378549B5D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jun 2016 23:18:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h7qG6pMKhnNB for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Jun 2016 23:18:05 -0400 (EDT)
Received: from postman.riken.jp (postman4.riken.jp [134.160.33.86])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D15C49B54
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jun 2016 23:18:04 -0400 (EDT)
In-Reply-To: <20160629124342.GV26498@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Christoffer,

On 6/29/16 9:43 PM, Christoffer Dall wrote:
> Doesn't this change carry the risk of KVM mapping a page (larger than
> 4K) containing other things than the GICV interface into the guest,
> potentially breaking isolation of the VM from host hardware resources?

I still suspect the 64Kb long region is filled with 16 copies of first 
4Kb of GICV, as Joel said in a thread two years ago when Marc introduced 
sub-page alignment patch:

https://patches.linaro.org/patch/32191/

. So with that patch applied, a VM always boots on a 64Kb page granular 
host, thanks to the multiple copies of the first part of GICV, but it'll 
have a problem accessing the GICV_DIR register that is
placed at the second 4Kb of region mapped for GICV.

For the ACPI enabled systems, the check of physical address of the 
virtual cpu interface is page aligned only works for 4Kb page granular 
kernels, so the patch is still required, though I need to come up with 
another patch that does map GICV to guest's physical address space 
taking care of the offset in the presence of the new VGIC code.
