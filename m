From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] VFIO: platform: AMD xgbe reset module
Date: Thu, 15 Oct 2015 17:03:21 +0200
Message-ID: <20151015150321.GA17484@cbox>
References: <1444836792-2405-1-git-send-email-eric.auger@linaro.org>
 <5270338.MbsQ1bGczu@wuerfel>
 <561FBC31.3020900@linaro.org>
 <37917545.AP0MxbQBzK@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <37917545.AP0MxbQBzK@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Eric Auger <eric.auger@linaro.org>, linux-arm-kernel@lists.infradead.org, eric.auger@st.com, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, thomas.lendacky@amd.com, patches@linaro.org, suravee.suthikulpanit@amd.com, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 15, 2015 at 04:55:13PM +0200, Arnd Bergmann wrote:
> On Thursday 15 October 2015 16:46:09 Eric Auger wrote:
> > > 
> > > This is where we'd need a little more changes for this approach. Instead
> > > of unbinding the device from its driver, the idea would be that the
> > > driver remains bound as far as the driver model is concerned, but
> > > it would be in a quiescent state where no other subsystem interacts with
> > > it (i.e. it gets unregistered from networking core or whichever it uses).
> > 
> > Currently we use the same mechanism as for PCI, ie. unbind the native
> > driver and then bind VFIO platform driver in its place. Don't you think
> > changing this may be a pain for user-space tools that are designed to
> > work that way for PCI?
> >
> > My personal preference would be to start with your first proposal since
> > it looks (to me) less complex and "unknown" that the 2d approach.
> 
> We certainly can't easily change from one approach to the other without
> breaking user expectations, so the decision needs to be made carefully.
> 
> The main observation here is that platform devices are unlike PCI in this
> regard because they need extra per-device code. I have argued in the
> past that we should not reuse the "VFIO" name here because it's actually
> something else.  

I've adjusted to consider VFIO a general purpose framework for mapping
device resources into userspace/VMs, and there are certainly a lot of
commonality with both PCI, platform, and potentially other devices for
that to make sense.


> On the other hand, there are a lot of commonalities,
> we just have to make sure we don't try to force the code into one model
> that doesn't really work just to make it look more like PCI VFIO.
> 

But given that we now have code for platform device passthrough that
works in both QEMU and the kernel side and is actually useful for
people, is there a clear technical advantage to go back and rework thaat
at this point?

Don't get me wrong, I like the idea of having a single driver bound to a
platform device, and then that's it, but it just feels like that
discussion doesn't necessarily belong in the context of a patch that
'just' seeks to add reset functionality for a specific device for VFIO?

-Christoffer
