Return-Path: <SRS0=xhzu=LJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2E17C48BDF
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 14:32:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 19D1361490
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 14:32:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 19D1361490
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64DD34B0CD;
	Tue, 15 Jun 2021 10:32:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aCkk--LIVPeL; Tue, 15 Jun 2021 10:32:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CEE944B0CB;
	Tue, 15 Jun 2021 10:32:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E38A4B0CE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 09:34:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p0nsHwQfkbWT for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Jun 2021 09:34:10 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6458A4B097
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 09:34:10 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF8716146D;
 Tue, 15 Jun 2021 13:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1623764049;
 bh=REF7Zyu6cbgt3VHjuTrKDBWw8/fKKSkHr0brWCx1WDY=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=tkUy3EPUFEC5VTgPlUyI6q6kNVNwNuv+cujwgXgPktfMgwoXCN95LVYvlr2Cxj5lz
 l7GoBU3O5grP+tSvw2b+HZzeV4cPkqgacG9kci2/x8y4ZXP/qpEimP9hJZ0eyIvDWb
 e5t98f1pDJrHOs1eMmm+HNMbbYx0y9UmuOFThQFo+VSYEuyk0VmOVUs27m7Z1XOQ8N
 OzmOPwdzQMYJWZIAF/rw5OQU4jmobLkJjH62eDzX9vHVkkrAFKFk73DgtornGy6rzc
 Q89kw18R9QHxO9McqK/4MPLseixa1r/dEtCbz2OYQIwQJI29SS6qjzYQ0ZfHpVymek
 F4bBAvgv4qHbg==
Date: Tue, 15 Jun 2021 16:34:05 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v9 0/5] KVM statistics data fd-based binary interface
Message-ID: <YMisTWKdyNgPvdQV@unreal>
References: <20210614212155.1670777-1-jingzhangos@google.com>
 <YMg5xPbmK3myjIX8@unreal>
 <15875c41-e1e7-3bf2-a85c-21384684d279@redhat.com>
 <YMhcek2cIu3Oz5Ek@unreal>
 <9df462c0-e0ea-8173-0705-369d6a81107c@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9df462c0-e0ea-8173-0705-369d6a81107c@redhat.com>
X-Mailman-Approved-At: Tue, 15 Jun 2021 10:32:51 -0400
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

On Tue, Jun 15, 2021 at 01:03:34PM +0200, Paolo Bonzini wrote:
> On 15/06/21 09:53, Leon Romanovsky wrote:
> > > Sorry for my naive questions, but how does telemetry get statistics
> > > for hypervisors? Why is KVM different from hypervisors or NIC's statistics
> > > or any other high speed devices (RDMA) that generate tons of data?
> > 
> > So the answer to the question "why KVM is different" is that it doesn't
> > have any stable identification except file descriptor. While hypervisors
> > have stable names, NICs and RDMA devices have interface indexes etc.
> > Did I get it right?
> 
> Right.
> 
> > And this was second part of my question, the first part was my attempt to
> > get on answer why current statistics like process info (/proc/xxx/*), NICs
> > (netlink) and RDMA (sysfs) are not using binary format.
> 
> NICs are using binary format (partly in struct ethtool_stats, partly in an
> array of u64).  For KVM we decided to put the schema and the stats in the
> same file (though you can use pread to get only the stats) to have a single
> interface and avoid ioctls, unlike having both ETH_GSTRINGS and ETH_GSTATS.
> 
> I wouldn't say processes are using any specific format.  There's a mix of
> "one value per file" (e.g. cpuset), human-readable tabular format (e.g.
> limits, sched), human- and machine-readable tabular format (e.g. status),
> and files that are ASCII but not human-readable (e.g. stat).

I see, your explanation to Enrico cleared the mud.

Thanks

> 
> Paolo
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
