From: Baptiste Reynal <b.reynal@virtualopensystems.com>
Subject: Re: [PATCH v4 0/5] vfio: type1: support for ARM SMMUS with
 VFIO_IOMMU_TYPE1
Date: Tue, 3 Mar 2015 11:07:16 +0100
Message-ID: <CAN9JPjFMLYFyRQ9i+9-K80H9C=zkroPDZ4cBk82g6Hyh=W0+gQ@mail.gmail.com>
References: <1425315507-29661-1-git-send-email-b.reynal@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8884118132916334700=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B92BE47811
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Mar 2015 05:01:17 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Bfn13XqLQRSM for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Mar 2015 05:01:17 -0500 (EST)
Received: from mail-qc0-f174.google.com (mail-qc0-f174.google.com
 [209.85.216.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F12E84780E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Mar 2015 05:01:16 -0500 (EST)
Received: by qcwb13 with SMTP id b13so29463220qcw.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 Mar 2015 02:07:16 -0800 (PST)
In-Reply-To: <1425315507-29661-1-git-send-email-b.reynal@virtualopensystems.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Linux IOMMU <iommu@lists.linux-foundation.org>, kvm-arm <kvmarm@lists.cs.columbia.edu>
Cc: VirtualOpenSystems Technical Team <tech@virtualopensystems.com>
List-Id: kvmarm@lists.cs.columbia.edu

--===============8884118132916334700==
Content-Type: multipart/alternative; boundary=001a11490592d65c7b05105f7fdb

--001a11490592d65c7b05105f7fdb
Content-Type: text/plain; charset=UTF-8

Added Eric Auger for comments.

On Mon, Mar 2, 2015 at 5:58 PM, Baptiste Reynal <
b.reynal@virtualopensystems.com> wrote:

> This patch series makes the VFIO_IOMMU_TYPE1 driver buildable on ARM, so it
> may be used with ARM SMMUs. It also adds support for the IOMMU_NOEXEC flag
> supported by SMMUs adhering to the ARM SMMU specification so the VFIO user
> can
> specify whether the target memory can be executed by the device behind the
> SMMU.
>
> Changes from v3:
>  - Rebased on linux v4.0-rc1
>  - Use bit shifting for domain->caps
>  - Baptiste Reynal is the new maintainer of this serie
> Changes from v2:
>  - Rebased on latest iommu/next branch by Joerg Roedel
> Changes from v1:
>  - Bugfixes and corrected some typos
>  - Use enum for VFIO IOMMU driver capabilities
>
> Antonios Motakis (5):
>   vfio: implement iommu driver capabilities with an enum
>   vfio: introduce the VFIO_DMA_MAP_FLAG_NOEXEC flag
>   vfio: type1: replace domain wide protection flags with supported
>     capabilities
>   vfio: type1: replace vfio_domains_have_iommu_cache with generic
>     function
>   vfio: type1: implement the VFIO_DMA_MAP_FLAG_NOEXEC flag
>
>  drivers/vfio/vfio_iommu_type1.c | 91
> +++++++++++++++++++++++++++++------------
>  include/uapi/linux/vfio.h       | 30 ++++++++------
>  2 files changed, 81 insertions(+), 40 deletions(-)
>
> --
> 2.3.1
>
>

--001a11490592d65c7b05105f7fdb
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Added Eric Auger for comments.</div><div class=3D"gmail_ex=
tra"><br><div class=3D"gmail_quote">On Mon, Mar 2, 2015 at 5:58 PM, Baptist=
e Reynal <span dir=3D"ltr">&lt;<a href=3D"mailto:b.reynal@virtualopensystem=
s.com" target=3D"_blank">b.reynal@virtualopensystems.com</a>&gt;</span> wro=
te:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-=
left:1px #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h=
5">This patch series makes the VFIO_IOMMU_TYPE1 driver buildable on ARM, so=
 it<br>
may be used with ARM SMMUs. It also adds support for the IOMMU_NOEXEC flag<=
br>
supported by SMMUs adhering to the ARM SMMU specification so the VFIO user =
can<br>
specify whether the target memory can be executed by the device behind the<=
br>
SMMU.<br>
<br>
Changes from v3:<br>
=C2=A0- Rebased on linux v4.0-rc1<br>
=C2=A0- Use bit shifting for domain-&gt;caps<br>
=C2=A0- Baptiste Reynal is the new maintainer of this serie<br>
Changes from v2:<br>
=C2=A0- Rebased on latest iommu/next branch by Joerg Roedel<br>
Changes from v1:<br>
=C2=A0- Bugfixes and corrected some typos<br>
=C2=A0- Use enum for VFIO IOMMU driver capabilities<br>
<br>
Antonios Motakis (5):<br>
=C2=A0 vfio: implement iommu driver capabilities with an enum<br>
=C2=A0 vfio: introduce the VFIO_DMA_MAP_FLAG_NOEXEC flag<br>
=C2=A0 vfio: type1: replace domain wide protection flags with supported<br>
=C2=A0 =C2=A0 capabilities<br>
=C2=A0 vfio: type1: replace vfio_domains_have_iommu_cache with generic<br>
=C2=A0 =C2=A0 function<br>
=C2=A0 vfio: type1: implement the VFIO_DMA_MAP_FLAG_NOEXEC flag<br>
<br>
=C2=A0drivers/vfio/vfio_iommu_type1.c | 91 +++++++++++++++++++++++++++++---=
---------<br>
=C2=A0include/uapi/linux/vfio.h=C2=A0 =C2=A0 =C2=A0 =C2=A0| 30 ++++++++----=
--<br>
=C2=A02 files changed, 81 insertions(+), 40 deletions(-)<br>
<br>
--<br>
2.3.1<br>
<br>
</div></div></blockquote></div><br></div>

--001a11490592d65c7b05105f7fdb--

--===============8884118132916334700==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8884118132916334700==--
