From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH v6] KVM: arm/arm64: Route vtimer events to user space
Date: Fri, 23 Sep 2016 14:36:51 +0200
Message-ID: <D82BA95A-A89E-46EB-93D2-197DF44433EC@suse.de>
References: <1474628854-69945-1-git-send-email-agraf@suse.de>
 <dd9267b6-2323-2d74-0553-71a89d05a654@redhat.com>
Mime-Version: 1.0 (1.0)
Content-Type: multipart/mixed; boundary="===============5595334666704486149=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D5DD49B63
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2016 08:27:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3bFegp1KQe+f for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Sep 2016 08:27:45 -0400 (EDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2B12349B5D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2016 08:27:44 -0400 (EDT)
In-Reply-To: <dd9267b6-2323-2d74-0553-71a89d05a654@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu


--===============5595334666704486149==
Content-Type: multipart/alternative;
	boundary=Apple-Mail-664A768C-5FBF-40D0-8DFE-B10CA48E3407
Content-Transfer-Encoding: 7bit


--Apple-Mail-664A768C-5FBF-40D0-8DFE-B10CA48E3407
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable



> Am 23.09.2016 um 14:11 schrieb Paolo Bonzini <pbonzini@redhat.com>:
>=20
>=20
>=20
>> On 23/09/2016 13:07, Alexander Graf wrote:
>> +        timer_ret =3D kvm_timer_sync_hwstate(vcpu);
>>=20
>>        kvm_vgic_sync_hwstate(vcpu);
>>=20
>>        preempt_enable();
>>=20
>>        ret =3D handle_exit(vcpu, run, ret);
>> +
>> +        if ((ret =3D=3D 1) && timer_ret) {
>> +            /*
>> +             * We have to exit straight away to ensure that we only
>> +             * ever notify user space once about a level change
>> +             */
>=20
> Is this really a requirement?  It complicates the logic noticeably.

The alternative would be to track the state on ioctl entry, which Christoffe=
r disliked :).


Alex


--Apple-Mail-664A768C-5FBF-40D0-8DFE-B10CA48E3407
Content-Type: text/html;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><head><meta http-equiv=3D"content-type" content=3D"text/html; charset=3D=
utf-8"></head><body dir=3D"auto"><div></div><div style=3D"direction: inherit=
;"><br></div><div><br>Am 23.09.2016 um 14:11 schrieb Paolo Bonzini &lt;<a hr=
ef=3D"mailto:pbonzini@redhat.com">pbonzini@redhat.com</a>&gt;:<br><br></div>=
<blockquote type=3D"cite"><div><span></span><br><span></span><br><span>On 23=
/09/2016 13:07, Alexander Graf wrote:</span><br><blockquote type=3D"cite"><s=
pan>+ &nbsp; &nbsp; &nbsp; &nbsp;timer_ret =3D kvm_timer_sync_hwstate(vcpu);=
</span><br></blockquote><blockquote type=3D"cite"><span></span><br></blockqu=
ote><blockquote type=3D"cite"><span>  &nbsp; &nbsp; &nbsp; &nbsp;kvm_vgic_sy=
nc_hwstate(vcpu);</span><br></blockquote><blockquote type=3D"cite"><span></s=
pan><br></blockquote><blockquote type=3D"cite"><span>  &nbsp; &nbsp; &nbsp; &=
nbsp;preempt_enable();</span><br></blockquote><blockquote type=3D"cite"><spa=
n></span><br></blockquote><blockquote type=3D"cite"><span>  &nbsp; &nbsp; &n=
bsp; &nbsp;ret =3D handle_exit(vcpu, run, ret);</span><br></blockquote><bloc=
kquote type=3D"cite"><span>+</span><br></blockquote><blockquote type=3D"cite=
"><span>+ &nbsp; &nbsp; &nbsp; &nbsp;if ((ret =3D=3D 1) &amp;&amp; timer_ret=
) {</span><br></blockquote><blockquote type=3D"cite"><span>+ &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp;/*</span><br></blockquote><blockquote type=3D"cite=
"><span>+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; * We have to exit straig=
ht away to ensure that we only</span><br></blockquote><blockquote type=3D"ci=
te"><span>+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; * ever notify user spa=
ce once about a level change</span><br></blockquote><blockquote type=3D"cite=
"><span>+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; */</span><br></blockquot=
e><span></span><br><span>Is this really a requirement? &nbsp;It complicates t=
he logic noticeably.</span><br></div></blockquote><div style=3D"direction: i=
nherit;"><br></div><div style=3D"direction: inherit;">The alternative would b=
e to track the state on ioctl entry, which Christoffer disliked :).</div><di=
v style=3D"direction: inherit;"><br></div><div style=3D"direction: inherit;"=
><br></div><div style=3D"direction: inherit;">Alex</div><div style=3D"direct=
ion: inherit;"><br></div></body></html>=

--Apple-Mail-664A768C-5FBF-40D0-8DFE-B10CA48E3407--

--===============5595334666704486149==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============5595334666704486149==--
