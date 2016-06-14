From: ib10evp0@gmx.org
Subject: Re: Re: Status of live migration on ARMv7
Date: Tue, 14 Jun 2016 22:52:41 +0200
Message-ID: <trinity-6f860951-3365-4cc6-986a-3b19853fd387-1465937561349@3capp-gmx-bs24>
References: <trinity-d5cbcace-be15-4c67-b55c-1a70d1fb7c21-1465735240100@3capp-gmx-bs77>,
 <20160614202025.226dd45d@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30E9F499A1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Jun 2016 16:48:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0bnFhANr9Q5p for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Jun 2016 16:48:12 -0400 (EDT)
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D57DF40C9D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Jun 2016 16:48:11 -0400 (EDT)
In-Reply-To: <20160614202025.226dd45d@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

> Everything that's needed for a typical ARMv7 is already in mainline,
> both for the kernel and qemu. And since the code is almost entirely
> shared with ARMv8, it is probably in the same state. If it not working,
> then it is a bug that should be addressed.
> 
> > BTW: The Migration page [3] claims the migration feature is hardware
> > independent but it remains unclear if this expands to CPU
> > architectures and if this applies to live migration or only offline
> > migration. Some clarification in this regard would be nice to have.
> 
> We do have support for live migration (migrating the VM whilst it is
> still running, tracking memory that gets dirtied).

After reading this it's still not entirely clear to me if live migration using
your definition is also available for ARMv7 in the mainline kernel. Could you
confirm this with one sentence, please? Sorry for the inconvenience.

If it's available I'll build a KVM virtualization cluster over the following
weeks and report any bugs I encounter.

Thank you.
