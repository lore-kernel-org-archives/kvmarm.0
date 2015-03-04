From: Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Subject: Re: [PATCH v4 0/5] vfio: type1: support for ARM SMMUS with
	VFIO_IOMMU_TYPE1
Date: Wed, 4 Mar 2015 16:21:42 +0100
Message-ID: <CAN9JPjEOHozQzQj9fdSww1ueC5yVdoBG=i=JYqDFMwNdosLvKQ@mail.gmail.com>
References: <1425315507-29661-1-git-send-email-b.reynal@virtualopensystems.com>
	<54F5F37E.2070002@linaro.org>
	<1425405715.5200.217.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8917584249395973182=="
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1425405715.5200.217.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Linux IOMMU <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, VirtualOpenSystems Technical Team <tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>, kvm-arm <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>, Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

--===============8917584249395973182==
Content-Type: multipart/alternative; boundary=001a11339844368966051078027a

--001a11339844368966051078027a
Content-Type: text/plain; charset=UTF-8

Thanks for your comments. A v5 is ongoing, with the removal of
domain->caps, instead domain->domain->ops->capable(cap) is tested.

Regards,
Baptiste

On Tue, Mar 3, 2015 at 7:01 PM, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
wrote:

> On Tue, 2015-03-03 at 18:46 +0100, Eric Auger wrote:
> > Hi Baptiste,
> >
> > In "vfio: type1: implement the VFIO_DMA_MAP_FLAG_NOEXEC flag" you still
> > kept domain->caps |= IOMMU_CAP_NOEXEC so potentially overwriting 1<<
> > IOMMU_CAP_CACHE_COHERENCY I guess.
> >
> > Sorry I do not have this 4th patch file in my mailbox.
> >
> > Best Regards
> >
> > Eric
> >
> >       if (iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
> >               domain->caps |= (1 << IOMMU_CAP_CACHE_COHERENCY);
> >
> >       if (iommu_capable(bus, IOMMU_CAP_NOEXEC))
> >               domain->caps |= IOMMU_CAP_NOEXEC;
>
>
> Patch 4/5 has problems too, vfio_domains_have_iommu_cap() is called with
> IOMMU_CAP_CACHE_COHERENCY, but nobody is shifting that into a bitmap
> before doing the comparison.
>
> TBH, I don't see the point of creating this artificial bitmap out of the
> capabilities.  Why can't we keep everything in the domain of actual
> flags passed to iommu_ops functions?  It's just silly to test for cached
> capability and re-invent the mapping flags on every mapping call and
> it's just as easy to generalize a test using the actual flags as to use
> the capabilities, perhaps easier.  Thanks,
>
> Alex
>
>
>
> > On 03/02/2015 05:58 PM, Baptiste Reynal wrote:
> > > This patch series makes the VFIO_IOMMU_TYPE1 driver buildable on ARM,
> so it
> > > may be used with ARM SMMUs. It also adds support for the IOMMU_NOEXEC
> flag
> > > supported by SMMUs adhering to the ARM SMMU specification so the VFIO
> user can
> > > specify whether the target memory can be executed by the device behind
> the
> > > SMMU.
> > >
> > > Changes from v3:
> > >  - Rebased on linux v4.0-rc1
> > >  - Use bit shifting for domain->caps
> > >  - Baptiste Reynal is the new maintainer of this serie
> > > Changes from v2:
> > >  - Rebased on latest iommu/next branch by Joerg Roedel
> > > Changes from v1:
> > >  - Bugfixes and corrected some typos
> > >  - Use enum for VFIO IOMMU driver capabilities
> > >
> > > Antonios Motakis (5):
> > >   vfio: implement iommu driver capabilities with an enum
> > >   vfio: introduce the VFIO_DMA_MAP_FLAG_NOEXEC flag
> > >   vfio: type1: replace domain wide protection flags with supported
> > >     capabilities
> > >   vfio: type1: replace vfio_domains_have_iommu_cache with generic
> > >     function
> > >   vfio: type1: implement the VFIO_DMA_MAP_FLAG_NOEXEC flag
> > >
> > >  drivers/vfio/vfio_iommu_type1.c | 91
> +++++++++++++++++++++++++++++------------
> > >  include/uapi/linux/vfio.h       | 30 ++++++++------
> > >  2 files changed, 81 insertions(+), 40 deletions(-)
> > >
> >
> > _______________________________________________
> > iommu mailing list
> > iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> > https://lists.linuxfoundation.org/mailman/listinfo/iommu
>
>
>
>

--001a11339844368966051078027a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>Thanks for your comments. A v5 is ongoing, with =
the removal of domain-&gt;caps, instead domain-&gt;domain-&gt;ops-&gt;capab=
le(cap) is tested.<br><br></div>Regards,<br></div>Baptiste<br><div><div><di=
v class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Tue, Mar 3, 2015 =
at 7:01 PM, Alex Williamson <span dir=3D"ltr">&lt;<a href=3D"mailto:alex.wi=
lliamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" target=3D"_blank">alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org</a>&gt;</=
span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8e=
x;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On Tue, 201=
5-03-03 at 18:46 +0100, Eric Auger wrote:<br>
&gt; Hi Baptiste,<br>
&gt;<br>
&gt; In &quot;vfio: type1: implement the VFIO_DMA_MAP_FLAG_NOEXEC flag&quot=
; you still<br>
&gt; kept domain-&gt;caps |=3D IOMMU_CAP_NOEXEC so potentially overwriting =
1&lt;&lt;<br>
&gt; IOMMU_CAP_CACHE_COHERENCY I guess.<br>
&gt;<br>
&gt; Sorry I do not have this 4th patch file in my mailbox.<br>
&gt;<br>
&gt; Best Regards<br>
&gt;<br>
&gt; Eric<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (iommu_capable(bus, IOMMU_CAP_CACHE_COHER=
ENCY))<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0domain-&gt;caps =
|=3D (1 &lt;&lt; IOMMU_CAP_CACHE_COHERENCY);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (iommu_capable(bus, IOMMU_CAP_NOEXEC))<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0domain-&gt;caps =
|=3D IOMMU_CAP_NOEXEC;<br>
<br>
<br>
</span>Patch 4/5 has problems too, vfio_domains_have_iommu_cap() is called =
with<br>
IOMMU_CAP_CACHE_COHERENCY, but nobody is shifting that into a bitmap<br>
before doing the comparison.<br>
<br>
TBH, I don&#39;t see the point of creating this artificial bitmap out of th=
e<br>
capabilities.=C2=A0 Why can&#39;t we keep everything in the domain of actua=
l<br>
flags passed to iommu_ops functions?=C2=A0 It&#39;s just silly to test for =
cached<br>
capability and re-invent the mapping flags on every mapping call and<br>
it&#39;s just as easy to generalize a test using the actual flags as to use=
<br>
the capabilities, perhaps easier.=C2=A0 Thanks,<br>
<br>
Alex<br>
<div><div class=3D"h5"><br>
<br>
<br>
&gt; On 03/02/2015 05:58 PM, Baptiste Reynal wrote:<br>
&gt; &gt; This patch series makes the VFIO_IOMMU_TYPE1 driver buildable on =
ARM, so it<br>
&gt; &gt; may be used with ARM SMMUs. It also adds support for the IOMMU_NO=
EXEC flag<br>
&gt; &gt; supported by SMMUs adhering to the ARM SMMU specification so the =
VFIO user can<br>
&gt; &gt; specify whether the target memory can be executed by the device b=
ehind the<br>
&gt; &gt; SMMU.<br>
&gt; &gt;<br>
&gt; &gt; Changes from v3:<br>
&gt; &gt;=C2=A0 - Rebased on linux v4.0-rc1<br>
&gt; &gt;=C2=A0 - Use bit shifting for domain-&gt;caps<br>
&gt; &gt;=C2=A0 - Baptiste Reynal is the new maintainer of this serie<br>
&gt; &gt; Changes from v2:<br>
&gt; &gt;=C2=A0 - Rebased on latest iommu/next branch by Joerg Roedel<br>
&gt; &gt; Changes from v1:<br>
&gt; &gt;=C2=A0 - Bugfixes and corrected some typos<br>
&gt; &gt;=C2=A0 - Use enum for VFIO IOMMU driver capabilities<br>
&gt; &gt;<br>
&gt; &gt; Antonios Motakis (5):<br>
&gt; &gt;=C2=A0 =C2=A0vfio: implement iommu driver capabilities with an enu=
m<br>
&gt; &gt;=C2=A0 =C2=A0vfio: introduce the VFIO_DMA_MAP_FLAG_NOEXEC flag<br>
&gt; &gt;=C2=A0 =C2=A0vfio: type1: replace domain wide protection flags wit=
h supported<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0capabilities<br>
&gt; &gt;=C2=A0 =C2=A0vfio: type1: replace vfio_domains_have_iommu_cache wi=
th generic<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0function<br>
&gt; &gt;=C2=A0 =C2=A0vfio: type1: implement the VFIO_DMA_MAP_FLAG_NOEXEC f=
lag<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 drivers/vfio/vfio_iommu_type1.c | 91 ++++++++++++++++++++++=
+++++++------------<br>
&gt; &gt;=C2=A0 include/uapi/linux/vfio.h=C2=A0 =C2=A0 =C2=A0 =C2=A0| 30 ++=
++++++------<br>
&gt; &gt;=C2=A0 2 files changed, 81 insertions(+), 40 deletions(-)<br>
&gt; &gt;<br>
&gt;<br>
</div></div>&gt; _______________________________________________<br>
&gt; iommu mailing list<br>
&gt; <a href=3D"mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org">iommu-cunTk1MwBs/ROKNJybVBZg@public.gmane.org=
foundation.org</a><br>
&gt; <a href=3D"https://lists.linuxfoundation.org/mailman/listinfo/iommu" t=
arget=3D"_blank">https://lists.linuxfoundation.org/mailman/listinfo/iommu</=
a><br>
<br>
<br>
<br>
</blockquote></div><br></div></div></div></div>

--001a11339844368966051078027a--

--===============8917584249395973182==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8917584249395973182==--
