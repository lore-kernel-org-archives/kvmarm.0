From: Will Deacon <will.deacon@arm.com>
Subject: [ANNOUNCE] Stand-alone kvmtool repository
Date: Wed, 3 Jun 2015 18:25:08 +0100
Message-ID: <20150603172508.GM17581@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: kvm@vger.kernel.org
Cc: Pekka Enberg <penberg@iki.fi>, Andre Przywara <Andre.Przywara@arm.com>, Sasha Levin <sasha.levin@oracle.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Ronald Minnich <rminnich@google.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, rmk@arm.linux.org.uk
List-Id: kvmarm@lists.cs.columbia.edu

Hi all,

Thanks to a tonne of help (and friendly nagging!) from Andre, I'm
pleased to announce a stand-alone repository for kvmtool:

  git://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git

This is a follow-up from a previous thread[1] where we concluded that
this was the right way to go. As requested, the original git history is
preserved but is *not* bisectable since we don't include the kernel tree
in the history. For a bisectable history, the original github repo[2]
should be used instead.

For now, it's living in my area of kernel.org since (a) I already had a
fork there and (b) the patch traffic is pretty low for the project. If
there is sufficient development interest, I can move it somewhere more
appropriate for shared maintenance (e.g. under virt/kvm/).

Anyway, please give it a spin and send patches when it falls over ;)

Will

[1] https://lkml.org/lkml/2015/2/23/393
[2] git://github.com/penberg/linux-kvm.git
