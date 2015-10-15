From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] VFIO: platform: AMD xgbe reset module
Date: Thu, 15 Oct 2015 16:28:17 +0200
Message-ID: <9585756.nfBEboTrrV@wuerfel>
References: <1444836792-2405-1-git-send-email-eric.auger@linaro.org>
 <20151015121228.GA965@cbox> <561FB63E.4070404@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A97141711
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2015 10:26:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6UU5Pc+j--Sh for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Oct 2015 10:26:42 -0400 (EDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2311241451
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2015 10:26:41 -0400 (EDT)
In-Reply-To: <561FB63E.4070404@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>
Cc: thomas.lendacky@amd.com, kvm@vger.kernel.org, patches@linaro.org, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, suravee.suthikulpanit@amd.com, eric.auger@st.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thursday 15 October 2015 16:20:46 Eric Auger wrote:
> On 10/15/2015 02:12 PM, Christoffer Dall wrote:
> > On Thu, Oct 15, 2015 at 01:21:55PM +0200, Arnd Bergmann wrote:
> >> On Thursday 15 October 2015 10:08:02 Eric Auger wrote:
> >>> On 10/14/2015 05:38 PM, Arnd Bergmann wrote:
> >>>> On Wednesday 14 October 2015 15:33:12 Eric Auger wrote:
> >> A possible solution could be something inside the xgbe driver like
> >>
> >>
> >> static void xgbe_init_module(void)
> >> {
> >> 	int ret = 0;
> >>
> >> 	if (IS_ENABLED(CONFIG_AMD_XGBE_ETHERNET)
> >> 		ret = platform_driver_register(&xgbe_driver);
> >> 	if (ret)
> >> 		return ret;
> >>
> >> 	if (IS_ENABLED(CONFIG_VFIO_PLATFORM))
> >> 		ret = vfio_platform_register_reset(&xgbe_of_match, xgbe_platform_reset);
> >>
> >> 	return ret;	
> >> }
> >>
> >> This way you have exactly one driver module that gets loaded for the
> >> device and you can use it either with the platform_driver or through
> >> vfio.
> If I understand it correctly you still need 2 loaded modules (VFIO
> driver & XGBE driver which implements the reset function) or am I
> missing something?

That is correct, yes.
 
> I had a similar mechanism of registration in my PATCH v1 but I did the
> registration from the reset module itself instead of in the native
> driver, as you suggest here.

Right. The main difference is that you don't have two modules fighting
over the same device with the approach here.

	Arnd
