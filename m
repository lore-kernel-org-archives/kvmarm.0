From: Andrew Jones <drjones@redhat.com>
Subject: Re: Aarch64 vm-spec validation tools
Date: Wed, 21 Dec 2016 16:53:04 +0100
Message-ID: <20161221155304.udmypqv4plz6s46a@kamzik.brq.redhat.com>
References: <CAAqcGHmj5PgCgLJzhQmO0oCzyitGA83415ALrXbvoGQdyJYKRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 19ED54044B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Dec 2016 10:51:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pnACVDEFAMg8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Dec 2016 10:51:50 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E0A7A40223
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Dec 2016 10:51:50 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <CAAqcGHmj5PgCgLJzhQmO0oCzyitGA83415ALrXbvoGQdyJYKRg@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Riku Voipio <riku.voipio@linaro.org>
Cc: "cross-distro@lists.linaro.org" <cross-distro@lists.linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Riku,

Thanks for this. I have a couple images that fail the VMSPEC-IMAGE-GPT and
VMSPEC-IMAGE-ESP tests, even though they shouldn't. This appears to be due
to how the root device is found, as well as how GPT type is determined.
Maybe using blkid instead of, or as well as, df could help.

Also, I think you may find using libguestfs (which has python bindings)
a good way to handle multiple image / file system types for the image
verify feature. And, libguestfs supports a 'add-drive-ro' feature that
uses a snapshot mode like vmspec-verify does, but does not require the
nbd module be loaded on the host.

Thanks,
drew


On Wed, Dec 21, 2016 at 01:25:14PM +0200, Riku Voipio wrote:
> Hi,
> 
> Some time ago we drafted a specification[1] for AArch64 virtual
> machines. Now we are launching verification tools that let everyone
> verify that the whole stack (host hypervisor, guest firmware and guest
> OS image) implements the spec:
> 
> https://github.com/linaro/vmspec-tools
> 
> For some extra background see the blog post on vmspec:
> 
> http://www.linaro.org/blog/core-dump/ensuring-bootable-arm-vm-images/
> 
> From the cross-distro point of view, we are interested in finding out if
> 
> - QEMU shipped is new enough (2.6+)
> - a compatible EFI for arm64 guests is available
> - a vmspec compatible cloud guest image is available
> 
> If the image comes with cloud-init, vmspec-boot can be used directly
> to verify compliance. Without cloud-init, one can run vmspec-verify
> inside the guest to verify manually.
> 
> The tools are still under development, for example the ACPI test
> returns a failure even if the guest would support ACPI if forced.
> Feedback and patches are always welcome.
> 
> The README.md lists a handful of guest images that have been used in
> testing. I'd be most happy to add more links to the list!
> 
> Riku
> 
> [1] http://www.linaro.org/app/resources/WhitePaper/VMSystemSpecificationForARM-v2.0.pdf
