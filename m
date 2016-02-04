From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 07/11] arm/pci: PCI device operation test
Date: Thu, 4 Feb 2016 16:31:17 +0100
Message-ID: <20160204153117.GE3890@hawk.localdomain>
References: <cover.1452341807.git.agordeev@redhat.com>
 <597fba0ba6cdc84495acd7dd2119d9c785a76548.1452341807.git.agordeev@redhat.com>
 <20160115153211.GL3915@hawk.localdomain>
 <20160204121837.GB15617@dhcp-27-118.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 466B0412DD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2016 10:25:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6zQtUz6Uemoe for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2016 10:25:53 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0A407412C2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2016 10:25:52 -0500 (EST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
 (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
 by mx1.redhat.com (Postfix) with ESMTPS id 26B35C0A8469
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2016 15:31:21 +0000 (UTC)
Content-Disposition: inline
In-Reply-To: <20160204121837.GB15617@dhcp-27-118.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexander Gordeev <agordeev@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 04, 2016 at 01:18:38PM +0100, Alexander Gordeev wrote:
> On Fri, Jan 15, 2016 at 04:32:11PM +0100, Andrew Jones wrote:
> > > +struct pci_testdev_ops {
> > > +	u8 (*read8)(const volatile void *addr);
> > > +	u16 (*read16)(const volatile void *addr);
> > > +	u32 (*read32)(const volatile void *addr);
> > > +	void (*write8)(u8 value, volatile void *addr);
> > > +	void (*write16)(u16 value, volatile void *addr);
> > > +	void (*write32)(u32 value, volatile void *addr);
> > 
> > Please use the standard 'b', 'w', 'l' in these names.
> 
> I did not use in the first place as it conflicts with standard
> read*/write* macros. Would [read|write]_[byte|word|long] work
> for you?

Oh yeah... dang macros. _byte/word/dword like the pci_config_read/write
function in Linux would work.

drew
