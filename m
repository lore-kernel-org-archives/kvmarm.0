Return-Path: <SRS0=xhzu=LJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAE40C49361
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 09:45:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 55B3E613ED
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 09:45:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 55B3E613ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B1C44A3A3;
	Tue, 15 Jun 2021 05:45:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I1XB7CSdfKOA; Tue, 15 Jun 2021 05:45:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 210884B0F6;
	Tue, 15 Jun 2021 05:45:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D86C04B0A1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 03:53:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cZ4c37e-VtKw for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Jun 2021 03:53:35 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B91224B085
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 03:53:35 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4086B60E09;
 Tue, 15 Jun 2021 07:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1623743613;
 bh=vDFtBhlYLrwtZnXOmkUZxpC5WdGn3oEPAkfut4CQqlM=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=k5TCBQVSBuiL6rRGP41YwOT3DJImXi6Z1ty8MpV5XWkPGRguUfc9uqH2nPdbuWVKF
 nvKqUgp1gYQEozxBTNl+B8OwZn6E0A0Azee9sgNbBFp5f2BF9MrCeazfECaTgWqA9R
 IbVaQdoTKURDMZqti9x/Eraat8P4E50XDSuVD+MuJCPgtp9VnY24fi2kAu85igKzhD
 0A1BkJXNkIQZLCyCOJWVgqoq+ZvwfFA4F+e8cmCvtDh1bylcfCG/QNJysbdmDUL8NF
 wKqmAxU0QdRufELcUgnOVFU0l12rQxTX29JTQBnJJY+L0yB5UefYMAD5OIhB88ScBU
 CFl88in6YsOAw==
Date: Tue, 15 Jun 2021 10:53:30 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v9 0/5] KVM statistics data fd-based binary interface
Message-ID: <YMhcek2cIu3Oz5Ek@unreal>
References: <20210614212155.1670777-1-jingzhangos@google.com>
 <YMg5xPbmK3myjIX8@unreal>
 <15875c41-e1e7-3bf2-a85c-21384684d279@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <15875c41-e1e7-3bf2-a85c-21384684d279@redhat.com>
X-Mailman-Approved-At: Tue, 15 Jun 2021 05:45:20 -0400
Cc: KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Paul Mackerras <paulus@ozlabs.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 LinuxS390 <linux-s390@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 David Rientjes <rientjes@google.com>, KVMPPC <kvm-ppc@vger.kernel.org>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 David Matlack <dmatlack@google.com>, Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Peter Shier <pshier@google.com>, LinuxMIPS <linux-mips@vger.kernel.org>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Tue, Jun 15, 2021 at 09:06:43AM +0200, Paolo Bonzini wrote:
> On 15/06/21 07:25, Leon Romanovsky wrote:
> > Sorry for my naive questions, but how does telemetry get statistics
> > for hypervisors? Why is KVM different from hypervisors or NIC's statistics
> > or any other high speed devices (RDMA) that generate tons of data?
> 
> Right now, the only way is debugfs but it's slow, and it's disabled when
> using lockdown mode; this series is a way to fix this.
> 
> I sense that there is another question in there; are you wondering if
> another mechanism should be used, for example netlink?  The main issue there
> is how to identify a VM, since KVM file descriptors don't have a name.
> Using a pid works (sort of) for debugfs, but pids are not appropriate for a
> stable API.  Using a file descriptor as in this series requires
> collaboration from the userspace program; howver, once the file descriptor
> has been transmitted via SCM_RIGHTS, telemetry can read it forever without
> further IPC, and there is proper privilege separation.

Yeah, sorry for mixing different questions into one.

So the answer to the question "why KVM is different" is that it doesn't
have any stable identification except file descriptor. While hypervisors
have stable names, NICs and RDMA devices have interface indexes e.t.c.
Did I get it right?

And this was second part of my question, the first part was my attempt to
get on answer why current statistics like process info (/proc/xxx/*), NICs
(netlink) and RDMA (sysfs) are not using binary format.

Thanks

> 
> Paolo
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
