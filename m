From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm64: KVM: Remove duplicating init code for setting VMID
Date: Thu, 22 Sep 2016 11:02:17 +0100
Message-ID: <57E3AC29.1090404@arm.com>
References: <1474532281-37917-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E1DE49B2E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2016 05:53:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FnHe7JzrD43A for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Sep 2016 05:53:11 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BB5F40F77
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2016 05:53:11 -0400 (EDT)
In-Reply-To: <1474532281-37917-1-git-send-email-vladimir.murzin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vladimir Murzin <vladimir.murzin@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 22/09/16 09:18, Vladimir Murzin wrote:
> By now both VHE and non-VHE initialisation sequences query supported
> VMID size. Lets keep only single instance of this code under
> init_common_resources().
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> ---
>  arch/arm/kvm/arm.c |   12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
