From: Baptiste Reynal <b.reynal@virtualopensystems.com>
Subject: Re: [RFC PATCH v4 2/3] vfio: platform: access device property as a
 list of strings
Date: Thu, 10 Sep 2015 08:37:14 +0200
Message-ID: <CAN9JPjHvdLF=MhXXeC2tCF+BD9po4m9=FWnyzs7FT+hUEW_pfw@mail.gmail.com>
References: <1441790231-22920-1-git-send-email-b.reynal@virtualopensystems.com>
 <1441790231-22920-3-git-send-email-b.reynal@virtualopensystems.com>
 <1441831724.20355.541.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============9050415200186970180=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 04FB341278
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2015 02:36:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IcCM8McF2a5P for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Sep 2015 02:36:33 -0400 (EDT)
Received: from mail-qg0-f49.google.com (mail-qg0-f49.google.com
 [209.85.192.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 087E9411E3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2015 02:36:32 -0400 (EDT)
Received: by qgt47 with SMTP id 47so27810308qgt.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Sep 2015 23:37:14 -0700 (PDT)
In-Reply-To: <1441831724.20355.541.camel@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "open list:VFIO PLATFORM DRIVER" <kvm@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Linux IOMMU <iommu@lists.linux-foundation.org>, VirtualOpenSystems Technical Team <tech@virtualopensystems.com>, kvm-arm <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

--===============9050415200186970180==
Content-Type: multipart/alternative; boundary=001a1136fd326bcc9e051f5ed44c

--001a1136fd326bcc9e051f5ed44c
Content-Type: text/plain; charset=UTF-8

On Wed, Sep 9, 2015 at 10:48 PM, Alex Williamson <alex.williamson@redhat.com
> wrote:

> On Wed, 2015-09-09 at 11:17 +0200, Baptiste Reynal wrote:
> > From: Antonios Motakis <a.motakis@virtualopensystems.com>
> >
> > Certain device properties (e.g. the device node name, the compatible
> > string), are available as a list of strings (separated by the null
> > terminating character). Let the VFIO user query this type of properties.
> >
> > Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> > Signed-off-by: Baptiste Reynal <b.reynal@virtualopensystems.com>
> >
> > ---
> > v3 -> v4:
> >  - The list length is computed before strings copy. If the entire list
> >    doesn't fit, no strings are copied to the user.
> > ---
> >  drivers/vfio/platform/properties.c | 43
> +++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 42 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/vfio/platform/properties.c
> b/drivers/vfio/platform/properties.c
> > index 98754c2..8bf9c8f 100644
> > --- a/drivers/vfio/platform/properties.c
> > +++ b/drivers/vfio/platform/properties.c
> > @@ -22,7 +22,48 @@ static int dev_property_get_strings(struct device
> *dev, uint32_t *flags,
> >                                   char *name, unsigned *lenp,
> >                                   void __user *datap, unsigned long
> datasz)
> >  {
> > -     return -EINVAL;
> > +     const char **val;
> > +     int n, i, ret;
> > +
> > +     if (lenp == NULL)
> > +             return -EFAULT;
>
> Paranoia?
>

Kind of, automatic reflex.


>
> > +
> > +     *lenp = 0;
> > +
> > +     n = device_property_read_string_array(dev, name, NULL, 0);
> > +     if (n < 0)
> > +             return n;
> > +
> > +     val = kcalloc(n, sizeof(char *), GFP_KERNEL);
> > +     if (!val)
> > +             return -ENOMEM;
> > +
> > +     ret = device_property_read_string_array(dev, name, val, n);
> > +     if (ret < 0)
> > +             goto out;
> > +
> > +     for (i = 0; i < n; i++)
> > +             *lenp += strlen(val[i]) + 1;
> > +
> > +     if (datasz < *lenp) {
> > +             ret = -E2BIG;
> > +             goto out;
> > +     }
> > +
> > +     for (i = 0; i < n; i++) {
> > +             size_t len = strlen(val[i]) + 1;
> > +
> > +             if (copy_to_user(datap, val[i], strlen(val[i]) + 1)) {
>
> No need to call strlen() again here
>

Thanks, will be fixed.


>
> > +                     ret = -EFAULT;
> > +                     goto out;
> > +             }
> > +
> > +             datap += len;
> > +     }
> > +
> > +out:
> > +     kfree(val);
> > +     return ret;
> >  }
> >
> >  static int dev_property_get_uint(struct device *dev, uint32_t *flags,
>
>
>
>

--001a1136fd326bcc9e051f5ed44c
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">On Wed, Sep 9, 2015 at 10:48 PM, Alex Williamson <span dir=3D"ltr">&lt;=
<a href=3D"mailto:alex.williamson@redhat.com" target=3D"_blank">alex.willia=
mson@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" =
style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><di=
v class=3D"HOEnZb"><div class=3D"h5">On Wed, 2015-09-09 at 11:17 +0200, Bap=
tiste Reynal wrote:<br>
&gt; From: Antonios Motakis &lt;<a href=3D"mailto:a.motakis@virtualopensyst=
ems.com">a.motakis@virtualopensystems.com</a>&gt;<br>
&gt;<br>
&gt; Certain device properties (e.g. the device node name, the compatible<b=
r>
&gt; string), are available as a list of strings (separated by the null<br>
&gt; terminating character). Let the VFIO user query this type of propertie=
s.<br>
&gt;<br>
&gt; Signed-off-by: Antonios Motakis &lt;<a href=3D"mailto:a.motakis@virtua=
lopensystems.com">a.motakis@virtualopensystems.com</a>&gt;<br>
&gt; Signed-off-by: Baptiste Reynal &lt;<a href=3D"mailto:b.reynal@virtualo=
pensystems.com">b.reynal@virtualopensystems.com</a>&gt;<br>
&gt;<br>
&gt; ---<br>
&gt; v3 -&gt; v4:<br>
&gt;=C2=A0 - The list length is computed before strings copy. If the entire=
 list<br>
&gt;=C2=A0 =C2=A0 doesn&#39;t fit, no strings are copied to the user.<br>
&gt; ---<br>
&gt;=C2=A0 drivers/vfio/platform/properties.c | 43 ++++++++++++++++++++++++=
+++++++++++++-<br>
&gt;=C2=A0 1 file changed, 42 insertions(+), 1 deletion(-)<br>
&gt;<br>
&gt; diff --git a/drivers/vfio/platform/properties.c b/drivers/vfio/platfor=
m/properties.c<br>
&gt; index 98754c2..8bf9c8f 100644<br>
&gt; --- a/drivers/vfio/platform/properties.c<br>
&gt; +++ b/drivers/vfio/platform/properties.c<br>
&gt; @@ -22,7 +22,48 @@ static int dev_property_get_strings(struct device *=
dev, uint32_t *flags,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0char *name, unsigned=
 *lenp,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0void __user *datap, =
unsigned long datasz)<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0return -EINVAL;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0const char **val;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int n, i, ret;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (lenp =3D=3D NULL)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EFAULT;<br>
<br>
</div></div>Paranoia?<br></blockquote><div><br></div><div>Kind of, automati=
c reflex.<br></div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<div><div class=3D"h5"><br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0*lenp =3D 0;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0n =3D device_property_read_string_array(dev, name=
, NULL, 0);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (n &lt; 0)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return n;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0val =3D kcalloc(n, sizeof(char *), GFP_KERNEL);<b=
r>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!val)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -ENOMEM;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0ret =3D device_property_read_string_array(dev, na=
me, val, n);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (ret &lt; 0)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; n; i++)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*lenp +=3D strlen(val=
[i]) + 1;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (datasz &lt; *lenp) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D -E2BIG;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; n; i++) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0size_t len =3D strlen=
(val[i]) + 1;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (copy_to_user(data=
p, val[i], strlen(val[i]) + 1)) {<br>
<br>
</div></div>No need to call strlen() again here<br></blockquote><div><br></=
div><div>Thanks, will be fixed.<br></div><div>=C2=A0</div><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0ret =3D -EFAULT;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0goto out;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0datap +=3D len;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +out:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0kfree(val);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return ret;<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt;=C2=A0 static int dev_property_get_uint(struct device *dev, uint32_t *f=
lags,<br>
<br>
<br>
<br>
</div></div></blockquote></div><br></div></div>

--001a1136fd326bcc9e051f5ed44c--

--===============9050415200186970180==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============9050415200186970180==--
