From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 06/10] KVM: arm64: guest debug, add SW break point
 support
Date: Tue, 28 Apr 2015 14:56:45 +0200
Message-ID: <20150428125645.GA4137@cbox>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-7-git-send-email-alex.bennee@linaro.org>
 <20150414082558.GS6186@cbox>
 <87y4li6hua.fsf@linaro.org>
 <20150427200407.GG23335@cbox>
 <CAFEAcA-Kh7Tn+kw9psL=gqme9ogAn+mM8Uco_HcJy=cqg72hbw@mail.gmail.com>
 <87wq0wr6dd.fsf@linaro.org>
 <CAFEAcA85i_1JybEFBg91NA3-LpAzYh4RSDnqryOd=rZN7gZP5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFEAcA85i_1JybEFBg91NA3-LpAzYh4RSDnqryOd=rZN7gZP5A@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>, Alexander Graf <agraf@suse.de>, Andrew Jones <drjones@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Zhichao Huang <zhichao.huang@linaro.org>, "J. Kiszka" <jan.kiszka@siemens.com>, David Hildenbrand <dahi@linux.vnet.ibm.com>, Bharat Bhushan <r65777@freescale.com>, bp@suse.de, Gleb Natapov <gleb@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 28, 2015 at 10:34:12AM +0100, Peter Maydell wrote:
> On 28 April 2015 at 09:42, Alex Benn=E9e <alex.bennee@linaro.org> wro=
te:
> > Peter Maydell <peter.maydell@linaro.org> writes:
> >> Does the kernel already have a conveniently implemented "inject
> >> exception into guest" lump of code? If so it might be less effort
> >> to do it that way round, maybe.
> >
> > So you pointed out we can't just re-inject the exceptions we get as=
 we
> > need to map from things like ESR_ELx_EC_WATCHPT_LOW to
> > ESR_ELx_EC_WATCHPT_CUR before re-injection.
> >
> > Of course if it is as simple as modifying the ESR_EL1 register and
> > returning +ve in the handle_exit path then I can do that but I assu=
med
> > if any other wrangling needs doing it should be done in userspace.
>=20
> Well, somebody's got to do it, and it's the same amount of work
> either way (fiddling with ESR, making sure we direct the guest
> to the right exception vector entry point, maybe a few other
> things).
>=20
We already have code in the kernel to inject data/instruction aborts,
but not sure how much benefit there is in re-using that.  It's up to yo=
u
really, but I think the kernel code should be clear about what the
intention is so that we don't end up in a situation where: (1) The
intended behavior is unclear/vague, and (2) it doesn't actually work in
practice so nobody can follow the code.

Thanks,
-Christoffer
