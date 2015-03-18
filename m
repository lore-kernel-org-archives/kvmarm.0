From: Christoffer Dall <cdall@cs.columbia.edu>
Subject: Re: linux-next: manual merge of the kvm-arm tree with Linus' tree
Date: Wed, 18 Mar 2015 08:55:37 +0100
Message-ID: <20150318075537.GC23225@cbox>
References: <20150318144111.1e56c6d9@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150318144111.1e56c6d9@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

On Wed, Mar 18, 2015 at 02:41:11PM +1100, Stephen Rothwell wrote:
> Hi all,
>=20
> Today's linux-next merge of the kvm-arm tree got a conflict in
> virt/kvm/arm/vgic.c between commit ae705930fca6 ("arm/arm64: KVM: Keep
> elrsr/aisr in sync with software model") from Linus' tree and commit
> 71760950bf3d ("arm/arm64: KVM: add a common vgic_queue_irq_to_lr fn")
> from the kvm-arm tree.
>=20
> I fixed it up (I think - see below) and can carry the fix as necessary
> (no action is required).
>=20
> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>=20
> diff --cc virt/kvm/arm/vgic.c
> index c9f60f524588,ffd937ca5141..000000000000
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@@ -982,9 -1092,7 +1098,8 @@@ bool vgic_queue_irq(struct kvm_vcpu *vc
>   		if (vlr.source =3D=3D sgi_source_id) {
>   			kvm_debug("LR%d piggyback for IRQ%d\n", lr, vlr.irq);
>   			BUG_ON(!test_bit(lr, vgic_cpu->lr_used));
> - 			vlr.state |=3D LR_STATE_PENDING;
> - 			vgic_set_lr(vcpu, lr, vlr);
> + 			vgic_queue_irq_to_lr(vcpu, irq, lr, vlr);
>  +			vgic_sync_lr_elrsr(vcpu, lr, vlr);
>   			return true;
>   		}
>   	}
> @@@ -1001,12 -1109,8 +1116,9 @@@
>  =20
>   	vlr.irq =3D irq;
>   	vlr.source =3D sgi_source_id;
> - 	vlr.state =3D LR_STATE_PENDING;
> - 	if (!vgic_irq_is_edge(vcpu, irq))
> - 		vlr.state |=3D LR_EOI_INT;
> -=20
> - 	vgic_set_lr(vcpu, lr, vlr);
> + 	vlr.state =3D 0;
> + 	vgic_queue_irq_to_lr(vcpu, irq, lr, vlr);
>  +	vgic_sync_lr_elrsr(vcpu, lr, vlr);
>  =20
>   	return true;
>   }


Looks great, thanks!
-Christoffer

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJVCS95AAoJEEtpOizt6ddywR0H/1UXxyoybEUz8Sp4efG0uHXK
c+kw+A2pMzjqW9Bj1uN+Dcin7uCBqbV2gu/232jHc3c6eGFoEUbr6FZLGC8yky+m
+Bd86FIhEsO9gRXj173/bQ/7m3agt6L2a3/lzeo4HAT6iULTCKQvg1KXTJxpDA0b
ba1hR1HSyPuLLdp8mY27Vr3jQPDQdcptfazyrLuVFuQj+lFdJreiJKEwx7/rPLYv
P6JFQyfEc6AJvF3Yj3bqjfMjuVVbwNuGkbY9+Sn1m7OfeD/bgA7t0RZSzDS2agiO
gZVd/Ienkd+1isyUOqksdDEG4X6BcejqGBk/IRqnwD1m3cjAEMc5i1iOsx2lwGc=
=P6ye
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
