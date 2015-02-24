From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: kvm [2087]: load/store instruction decoding not implemented
Date: Tue, 24 Feb 2015 15:22:40 +0000
Message-ID: <20150224152240.GR11603@redhat.com>
References: <20150224115935.GA26241@redhat.com>
 <CAFEAcA-+xCkUNirq0zqQFotCSAjR25V25SkzPH7ktDOXQuhoFA@mail.gmail.com>
 <20150224122925.GL11603@redhat.com> <20150224124710.GB21364@cbox>
 <20150224142512.GN11603@redhat.com> <20150224145516.GC21364@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7C764678D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 10:17:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fXTc9wRO1Zs6 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Feb 2015 10:17:03 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D52804678B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 10:17:02 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20150224145516.GC21364@cbox>
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
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 24, 2015 at 03:55:16PM +0100, Christoffer Dall wrote:
> Which QEMU version?

I'm using qemu-2.2.0-5.fc22.aarch64 which is qemu 2.2.0 plus a pile of
Fedora patches, including Laszlo's support for UEFI/AAVMF (which I'm
also using).

I have just tested against unpatched qemu from git, and it fails in
the same way.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-df lists disk usage of guests without needing to install any
software inside the virtual machine.  Supports Linux and Windows.
http://people.redhat.com/~rjones/virt-df/
