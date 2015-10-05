From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [RFC PATCH v5 0/3] vfio: platform: return device properties for a
 platform device
Date: Mon, 5 Oct 2015 11:07:35 +0100
Message-ID: <CAFEAcA_ZGaS__7LPFR_JJEs0=KpDNjYQB_ib2pNDLLp2S0zSMA@mail.gmail.com>
References: <1443604077-3155-1-git-send-email-b.reynal@virtualopensystems.com>
 <1443814099.26107.124.camel@redhat.com> <20151002202844.GD32011@cbox>
 <CAFEAcA84seKfSh94XFJZxBeBzRd=twj2QaFvjMeDKYhrWQu7Nw@mail.gmail.com>
 <20151005093739.GF9011@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB38A41291
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Oct 2015 06:06:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4id-q3PcpH9j for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Oct 2015 06:06:04 -0400 (EDT)
Received: from mail-vk0-f53.google.com (mail-vk0-f53.google.com
 [209.85.213.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 096764117C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Oct 2015 06:06:03 -0400 (EDT)
Received: by vkgd64 with SMTP id d64so93336176vkg.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 05 Oct 2015 03:07:54 -0700 (PDT)
In-Reply-To: <20151005093739.GF9011@cbox>
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
Cc: Alex Williamson <alex.williamson@redhat.com>, "tech@virtualopensystems.com" <tech@virtualopensystems.com>, iommu@lists.linux-foundation.org, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 5 October 2015 at 10:37, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> On Fri, Oct 02, 2015 at 11:53:07PM +0100, Peter Maydell wrote:
>>  * I don't really want to build in a lot of infrastructure into
>>    QEMU to either build the DTC compiler into it or else introduce
>>    a runtime dependency on the dtc binary
>
> what level of complexity are we really talking about here?  Doesn't QEMU
> already link against libfdt and doesn't it support exactly what we're
> trying to do here?

We link against libfdt, but libfdt is for manipulating and creating
dt binary blobs. As I understand it what sysfs exposes to userspace
is not a dt binary blob (or fragment thereof) but a bit of dt source.
libfdt doesn't do parsing of source into blobs; that is done by the
dtc compiler, which QEMU doesn't currently build and which is set
up to build only a separate command line binary anyway, not to be
a utility library for compiling dt sources.

Do correct me if I'm wrong about the sysfs interface -- if it is
just exposing dt blobs that would be easier to deal with.

> I also don't think this is the job of VFIO, assuming there is some
> better place to do this.  I initially thought exposing device properties
> in some canonical format from sysfs independently from whether the
> system was booted with ACPI or DT was the right thing to do, but the
> counter argument to this was essentially that the guest kernel needs the
> same description as the host kernel and therefore we really have to find
> a way to pass the HW description bits on to the guest.

So we end up with even more code to pass through ACPI table
fragments as well :-(

>> (except "don't do device passthrough for platform devices, insist
>> on a real bus like PCI"...)
>>
> While I appreciate the simplicity of this solution from our
> (maintainers') point of view, I still see the latter point as relatively
> moot.  We have hardware with 10G platform ethernet devices that people
> want to do device assignment on already, and I think we should try to
> find a reasonable set of boundaries for setups that we can support
> upstream instead of this becoming a black hole of derivative code bases
> to do this sort of thing.

Yeah, speaking more seriously I agree we do need to do something
here. It's just all irritatingly awkward...

thanks
-- PMM
