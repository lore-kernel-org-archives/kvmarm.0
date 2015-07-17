From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 00/12] kvmtool: Improve portability
Date: Fri, 17 Jul 2015 17:52:36 +0100
Message-ID: <20150717165235.GF8055@arm.com>
References: <1437148938-5394-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2E4058D3B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 12:40:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GBNzt9YL9mk6 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jul 2015 12:40:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0B9C58D25
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 12:40:41 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1437148938-5394-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Marc Zyngier <Marc.Zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jul 17, 2015 at 05:02:06PM +0100, Andre Przywara wrote:
> Hi,

Hi Andre,

> this is a collection of patches to bring kvmtool closer to standards
> compliance (with standards not necessarily meaning GNU only).
> With all those patches applied, you can compile kvmtool with newer
> C standards, with clang and against musl-libc.

Most of this looks good to me, thanks! I'll leave it to stew for a few
days on the list, but I'm planning to merge it all apart from the two
*printf clang hacks and the PAGE_SIZE patch which Szabolcs commented on.

Will
