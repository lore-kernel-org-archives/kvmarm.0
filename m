From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH 0/4] Initial KVM SVE support hacks
Date: Fri, 17 Nov 2017 16:45:03 +0000
Message-ID: <20171117164500.GH22781@e103592.cambridge.arm.com>
References: <1510936735-6762-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1897649D1F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Nov 2017 11:42:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wdV7kGJJ11Eo for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Nov 2017 11:42:45 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FA2949D14
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Nov 2017 11:42:45 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1510936735-6762-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Nov 17, 2017 at 04:38:51PM +0000, Dave Martin wrote:
> Throwing out an RFC here now that I've got something _sort of_ working.
> 
> This is based on the base SVE patches as now present in
> torvalds/master [1], but not on Christoffer's SVE optimisations (for

(That should be: Christoffer's _VHE_ optimisations, though if he
has some SVE optimisations I would naturally be interested...)

[...]

Cheers
---Dave
