From: Andrew Jones <drjones@redhat.com>
Subject: ARM: KVM/XEN: how should we support virt-what?
Date: Wed, 25 Mar 2015 10:44:42 +0100
Message-ID: <20150325094440.GB3163@hawk.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A47749A05
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2015 05:37:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hhFU+NzFhky3 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Mar 2015 05:37:57 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C77E49A01
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2015 05:37:56 -0400 (EDT)
Content-Disposition: inline
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, Ian.Campbell@citrix.com, stefano.stabellini@eu.citrix.com, tim@xen.org
Cc: kvm@vger.kernel.org, xen-devel@lists.xen.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hello ARM virt maintainers,

I'd like to start a discussion about supporting virt-what[1]. virt-what
allows userspace to determine if the system it's running on is running
in a guest, and of what type (KVM, Xen, etc.). Despite it being a best
effort tool, see the Caveat emptor in [1], it has become quite a useful
tool, and is showing up in different places, such as OpenStack. If you
look at the code[2], specifically [3], then you'll see how it works on
x86, which is to use the dedicated hypervisor cpuid leaves. I'm
wondering what equivalent we have, or can develop, for arm.
Here are some thoughts;
0) there's already something we can use, and I just need to be told
   about it.
1) be as similar as possible to x86 by dedicating some currently
   undefined sysreg bits. This would take buy-in from lots of parties,
   so is not likely the way to go.
2) create a specific DT node that will get exposed through sysfs, or
   somewhere.
3) same as (2), but just use the nodes currently in mach-virt's DT
   as the indication we're a guest. This would just be a heuristic,
   i.e. "have virtio mmio" && psci.method == hvc, or something,
   and we'd still need a way to know if we're kvm vs. xen vs. ??.

Thanks,
drew 

[1] http://people.redhat.com/~rjones/virt-what/
[2] http://git.annexia.org/?p=virt-what.git;a=summary
[3] http://git.annexia.org/?p=virt-what.git;a=blob_plain;f=virt-what-cpuid-helper.c;hb=HEAD
