From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 0/5] KVM ARM64 Migration Fixes
Date: Sat, 14 Mar 2015 13:44:28 +0100
Message-ID: <20150314124428.GA10935@cbox>
References: <1426266176-14933-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1426266176-14933-1-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Alex and Marc,

On Fri, Mar 13, 2015 at 05:02:51PM +0000, Alex Benn=E9e wrote:
> Some fairly minor updates from the last series I sent out:
>=20
>   - Re-based on v4.0-rc3
>   - Use KVM_MP_STATE_STOPPED instead of KVM_MP_STATE_HALTED
>   - Some minor textual tidy ups on commit msgs and comments
>   - Move the re-factored vgic_queue_irq_to_lr to before the active ch=
anges
>=20
> The branch I've been working with can be found at:
>=20
>   http://git.linaro.org/people/alex.bennee/linux.git
>   branch: migration/kvmarm-fixes-for-4.0-v3
>=20

These look good to me.

Marc, unless you have objections, I'll go ahead and take patch 5 as a
fix and get that in for the next -rc, and will queue the rest?  This
will conflict, but we can fix it up with the linux-next merge.


-Christoffer
