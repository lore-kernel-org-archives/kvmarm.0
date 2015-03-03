From: Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Subject: Re: [PATCH 1/1] iommu/arm-smmu: fix ARM_SMMU_FEAT_TRANS_OPS condition
Date: Tue, 3 Mar 2015 09:57:44 +0100
Message-ID: <CAN9JPjF6vu6dd1ZbsDMGETj_+UUXcK-mcO+PH_A6-K2U5Yrc=w@mail.gmail.com>
References: <1425315442-29584-1-git-send-email-b.reynal@virtualopensystems.com>
	<20150302172444.GB7919@arm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3237994777211180098=="
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20150302172444.GB7919-5wv7dgnIgG8@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org" <tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>, "kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org" <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>, "moderated list:ARM SMMU DRIVER" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

--===============3237994777211180098==
Content-Type: multipart/alternative; boundary=001a1144d81235302a05105e87cc

--001a1144d81235302a05105e87cc
Content-Type: text/plain; charset=UTF-8

Good point, I didn't thought about it. I will publish a new version with
your modifications.

Thanks

On Mon, Mar 2, 2015 at 6:24 PM, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org> wrote:

> On Mon, Mar 02, 2015 at 04:57:22PM +0000, Baptiste Reynal wrote:
> > This patch is a fix to "iommu/arm-smmu: add support for iova_to_phys
> > through ATS1PR".
> > According to ARM documentation, translation registers are optional even
> > in SMMUv1, so ID0_S1TS needs to be checked to verify their presence.
> >
> > Signed-off-by: Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
> > ---
> >  drivers/iommu/arm-smmu.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
> > index fc13dd5..d4beca4 100644
> > --- a/drivers/iommu/arm-smmu.c
> > +++ b/drivers/iommu/arm-smmu.c
> > @@ -1556,7 +1556,7 @@ static int arm_smmu_device_cfg_probe(struct
> arm_smmu_device *smmu)
> >               return -ENODEV;
> >       }
> >
> > -     if (smmu->version == 1 || (!(id & ID0_ATOSNS) && (id & ID0_S1TS)))
> {
> > +     if ((id & ID0_S1TS) && ((smmu->version == 1) || (id &
> ID0_ATOSNS))) {
> >               smmu->features |= ARM_SMMU_FEAT_TRANS_OPS;
> >               dev_notice(smmu->dev, "\taddress translation ops\n");
>
> I'm not sure this is a complete fix. Shouldn't we also check that the
> domain
> is a stage-1 domain in arm_smmu_iova_to_phys? (potential fixup below).
>
> Will
>
> --->8
>
> diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
> index fc13dd56953e..107163295cbc 100644
> --- a/drivers/iommu/arm-smmu.c
> +++ b/drivers/iommu/arm-smmu.c
> @@ -1288,12 +1288,15 @@ static phys_addr_t arm_smmu_iova_to_phys(struct
> iommu_domain *domain,
>                 return 0;
>
>         spin_lock_irqsave(&smmu_domain->pgtbl_lock, flags);
> -       if (smmu_domain->smmu->features & ARM_SMMU_FEAT_TRANS_OPS)
> +
> +       if (smmu_domain->smmu->features & ARM_SMMU_FEAT_TRANS_OPS &&
> +           smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
>                 ret = arm_smmu_iova_to_phys_hard(domain, iova);
> -       else
> +       } else {
>                 ret = ops->iova_to_phys(ops, iova);
> -       spin_unlock_irqrestore(&smmu_domain->pgtbl_lock, flags);
> +       }
>
> +       spin_unlock_irqrestore(&smmu_domain->pgtbl_lock, flags);
>         return ret;
>  }
>
>

--001a1144d81235302a05105e87cc
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Good point, I didn&#39;t thought about it. I will pub=
lish a new version with your modifications.<br><br></div>Thanks<br></div><d=
iv class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Mon, Mar 2, 2015=
 at 6:24 PM, Will Deacon <span dir=3D"ltr">&lt;<a href=3D"mailto:will.deaco=
n@arm.com" target=3D"_blank">will.deacon-5wv7dgnIgG8@public.gmane.org</a>&gt;</span> wrote:<br><=
blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px=
 #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On Mo=
n, Mar 02, 2015 at 04:57:22PM +0000, Baptiste Reynal wrote:<br>
&gt; This patch is a fix to &quot;iommu/arm-smmu: add support for iova_to_p=
hys<br>
&gt; through ATS1PR&quot;.<br>
&gt; According to ARM documentation, translation registers are optional eve=
n<br>
&gt; in SMMUv1, so ID0_S1TS needs to be checked to verify their presence.<b=
r>
&gt;<br>
&gt; Signed-off-by: Baptiste Reynal &lt;<a href=3D"mailto:b.reynal@virtualo=
pensystems.com">b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 drivers/iommu/arm-smmu.c | 2 +-<br>
&gt;=C2=A0 1 file changed, 1 insertion(+), 1 deletion(-)<br>
&gt;<br>
&gt; diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c<br>
&gt; index fc13dd5..d4beca4 100644<br>
&gt; --- a/drivers/iommu/arm-smmu.c<br>
&gt; +++ b/drivers/iommu/arm-smmu.c<br>
&gt; @@ -1556,7 +1556,7 @@ static int arm_smmu_device_cfg_probe(struct arm_=
smmu_device *smmu)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -ENODEV;<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (smmu-&gt;version =3D=3D 1 || (!(id &amp; ID0_=
ATOSNS) &amp;&amp; (id &amp; ID0_S1TS))) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if ((id &amp; ID0_S1TS) &amp;&amp; ((smmu-&gt;ver=
sion =3D=3D 1) || (id &amp; ID0_ATOSNS))) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0smmu-&gt;feature=
s |=3D ARM_SMMU_FEAT_TRANS_OPS;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_notice(smmu-=
&gt;dev, &quot;\taddress translation ops\n&quot;);<br>
<br>
</div></div>I&#39;m not sure this is a complete fix. Shouldn&#39;t we also =
check that the domain<br>
is a stage-1 domain in arm_smmu_iova_to_phys? (potential fixup below).<br>
<br>
Will<br>
<br>
---&gt;8<br>
<br>
diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c<br>
index fc13dd56953e..107163295cbc 100644<br>
--- a/drivers/iommu/arm-smmu.c<br>
+++ b/drivers/iommu/arm-smmu.c<br>
@@ -1288,12 +1288,15 @@ static phys_addr_t arm_smmu_iova_to_phys(struct iom=
mu_domain *domain,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(&amp;smmu_domain-&gt;pgtbl_lo=
ck, flags);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (smmu_domain-&gt;smmu-&gt;features &amp; ARM=
_SMMU_FEAT_TRANS_OPS)<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (smmu_domain-&gt;smmu-&gt;features &amp; ARM=
_SMMU_FEAT_TRANS_OPS &amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0smmu_domain-&gt;stage =3D=3D ARM_=
SMMU_DOMAIN_S1) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D arm_smmu_io=
va_to_phys_hard(domain, iova);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0else<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0} else {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D ops-&gt;iov=
a_to_phys(ops, iova);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock_irqrestore(&amp;smmu_domain-&gt;pgt=
bl_lock, flags);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock_irqrestore(&amp;smmu_domain-&gt;pgt=
bl_lock, flags);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;<br>
=C2=A0}<br>
<br>
</blockquote></div><br></div>

--001a1144d81235302a05105e87cc--

--===============3237994777211180098==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3237994777211180098==--
