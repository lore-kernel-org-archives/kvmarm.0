From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: ARM: KVM/XEN: how should we support virt-what?
Date: Thu, 26 Mar 2015 19:50:06 +0100
Message-ID: <CAKv+Gu9YcrO=c0OWD2P6AXjMxPyaz=LhtB81FiCijAEC=XuW6g@mail.gmail.com>
References: <20150325094440.GB3163@hawk.usersys.redhat.com>
 <20150326090150.GA3073@hawk.usersys.redhat.com>
 <alpine.DEB.2.02.1503261843410.9516@kaball.uk.xensource.com>
 <CAKv+Gu9fzhfu7nJQ9GYvPr33OcY3RP4Ssyx_0o7q-Cw4g8_5Bg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 39BBA49D57
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 14:43:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z83AZB8TXa7r for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Mar 2015 14:43:07 -0400 (EDT)
Received: from mail-ie0-f173.google.com (mail-ie0-f173.google.com
 [209.85.223.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DA5A549D54
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 14:43:07 -0400 (EDT)
Received: by iedfl3 with SMTP id fl3so60521217ied.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 11:50:08 -0700 (PDT)
In-Reply-To: <CAKv+Gu9fzhfu7nJQ9GYvPr33OcY3RP4Ssyx_0o7q-Cw4g8_5Bg@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>, KVM devel mailing list <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, tim@xen.org, "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 26 March 2015 at 19:49, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> On 26 March 2015 at 19:45, Stefano Stabellini
> <stefano.stabellini@eu.citrix.com> wrote:
>> On Thu, 26 Mar 2015, Andrew Jones wrote:
>>> On Wed, Mar 25, 2015 at 10:44:42AM +0100, Andrew Jones wrote:
>>> > Hello ARM virt maintainers,
>>> >
>>> > I'd like to start a discussion about supporting virt-what[1]. virt-what
>>> > allows userspace to determine if the system it's running on is running
>>> > in a guest, and of what type (KVM, Xen, etc.). Despite it being a best
>>> > effort tool, see the Caveat emptor in [1], it has become quite a useful
>>> > tool, and is showing up in different places, such as OpenStack. If you
>>> > look at the code[2], specifically [3], then you'll see how it works on
>>> > x86, which is to use the dedicated hypervisor cpuid leaves. I'm
>>> > wondering what equivalent we have, or can develop, for arm.
>>> > Here are some thoughts;
>>> > 0) there's already something we can use, and I just need to be told
>>> >    about it.
>>> > 1) be as similar as possible to x86 by dedicating some currently
>>> >    undefined sysreg bits. This would take buy-in from lots of parties,
>>> >    so is not likely the way to go.
>>> > 2) create a specific DT node that will get exposed through sysfs, or
>>> >    somewhere.
>>> > 3) same as (2), but just use the nodes currently in mach-virt's DT
>>> >    as the indication we're a guest. This would just be a heuristic,
>>> >    i.e. "have virtio mmio" && psci.method == hvc, or something,
>>> >    and we'd still need a way to know if we're kvm vs. xen vs. ??.
>>> >
>>> > Thanks,
>>> > drew
>>> >
>>> > [1] http://people.redhat.com/~rjones/virt-what/
>>> > [2] http://git.annexia.org/?p=virt-what.git;a=summary
>>> > [3] http://git.annexia.org/?p=virt-what.git;a=blob_plain;f=virt-what-cpuid-helper.c;hb=HEAD
>>>
>>> Thanks everyone for their responses. So, the current summary seems to
>>> be;
>>> 1) Xen has both a DT node and an ACPI table, virt-what can learn how
>>>    to probe those.
>>> 2) We don't have anything yet for KVM, and we're reluctant to create a
>>>    specific DT node. Anyway, we'd still need to address ACPI booted
>>>    guests some other way.
>>>
>>> For a short-term, DT-only, approach we could go with a heuristic, one
>>> that includes Marc's "if hypervisor node exists, then xen, else kvm"
>>> condition.
>>>
>>> How about SMBIOS for a long-term solution that works for both DT and
>>> ACPI? We're not populating SMBIOS for arm guests yet in qemu, but now
>>> that AAVMF has fw_cfg, we should be able to. On x86 we already have
>>> smbios populated from qemu, although not in a way that allows us to
>>> determine kvm vs. xen vs. tcg.
>>
>> I don't think that SMBIOS works with DT.
>>
>
> SMBIOS works fine with DT

... but it needs UEFI ...
