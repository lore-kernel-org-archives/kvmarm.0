From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 2/6] arm_gic_kvm.c: restore config before pending IRQs
Date: Mon, 2 Mar 2015 14:14:08 -0800
Message-ID: <20150302221408.GC12902@lvm>
References: <1424880159-29348-1-git-send-email-alex.bennee@linaro.org>
 <1424880159-29348-3-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1424880159-29348-3-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 25, 2015 at 04:02:34PM +0000, Alex Benn=E9e wrote:
> As there is logic to deal with the difference between edge and level
> triggered interrupts in the kernel we must ensure it knows the
> configuration of the IRQs before we restore the pending state.
>=20
> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
