From: Dave Martin <dave.martin@foss.arm.com>
Subject: Re: [PATCH v2 14/28] arm64/sve: Backend logic for setting the vector
 length
Date: Wed, 20 Sep 2017 12:09:04 +0100
Message-ID: <20170920110902.GG24231@e103592.cambridge.arm.com>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
 <1504198860-12951-15-git-send-email-Dave.Martin@arm.com>
 <FC5BA359-D37C-493C-87CD-146B83D3CCB5@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <FC5BA359-D37C-493C-87CD-146B83D3CCB5@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Alan Hayward <Alan.Hayward@arm.com>
Cc: Dave P Martin <Dave.Martin@arm.com>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>, "gdb@sourceware.org" <gdb@sourceware.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Catalin Marinas <Catalin.Marinas@arm.com>, Yao Qi <Yao.Qi@arm.com>, Will Deacon <Will.Deacon@arm.com>, Richard Sandiford <Richard.Sandiford@arm.com>, nd <nd@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Sep 20, 2017 at 10:59:55AM +0000, Alan Hayward wrote:
> (Resending without disclaimer)
> 
> > On 31 Aug 2017, at 18:00, Dave Martin <Dave.Martin@arm.com> wrote:
> 
> > 
> > +int sve_set_vector_length(struct task_struct *task,
> > +			  unsigned long vl, unsigned long flags)
> > +{
> > +	WARN_ON(task == current && preemptible());
> > +
> > +	if (flags & ~(unsigned long)(PR_SVE_VL_INHERIT |
> > +				     PR_SVE_SET_VL_ONEXEC))
> > +		return -EINVAL;
> > +
> > +	if (!sve_vl_valid(vl))
> > +		return -EINVAL;
> > +
> > +	/*
> > +	 * Clamp to the maximum vector length that VL-agnostic SVE code can
> > +	 * work with.  A flag may be assigned in the future to allow setting
> > +	 * of larger vector lengths without confusing older software.
> > +	 */
> > +	if (vl > SVE_VL_ARCH_MAX)
> > +		vl = SVE_VL_ARCH_MAX;
> > +
> > +	vl = find_supported_vector_length(vl);
> > +
> 
> 
> Given, sve_set_vector_length is called when setting the vector length in
> PTRACE_SETREGSET, it looks to me like if you set VL to a value that’s not
> supported by the hardware, then it’s going to round down to the previous value.
> Is that correct? I’m not sure if that’s explained in the docs?

Does this cover it?

"On success, the calling thread's vector length is changed to the
largest value supported by the system that is less than or equal to vl."

(For ptrace, I just cross-reference the PR_SVE_SET_VL behaviour, above.)

> What happens if you give a vl value lower than the min supported value in the
> hardware?

This is impossible, unless vl < SVE_VL_MIN (which is rejected explicitly
by the !sve_vl_valid() check in sve_set_vector_length()).

The architecture required support for all power-of-two vector lengths
less than the maximum supported vector length, so by construction
SVE_VL_MIN is supported by all hardware.

To be defensive, if we fail to detect support for SVE_VL_MIN, I set the
corresponding bit in sve_vq_map and WARN.  This is just to help ensure
find_supported_vector_length doesn't fall off the end of sve_vq_map.


Does that sounds correct?  There may be a clearer way of achieving this.

Cheers
---Dave

> 
> 
> > +/*
> > + * All vector length selection from userspace comes through here.
> > + * We're on a slow path, so some sanity-checks are included.
> > + * If things go wrong there's a bug somewhere, but try to fall back to a
> > + * safe choice.
> > + */
> > +static unsigned int find_supported_vector_length(unsigned int vl)
> > +{
> > +	int bit;
> > +	int max_vl = sve_max_vl;
> > +
> > +	if (WARN_ON(!sve_vl_valid(vl)))
> > +		vl = SVE_VL_MIN;
> > +
> > +	if (WARN_ON(!sve_vl_valid(max_vl)))
> > +		max_vl = SVE_VL_MIN;
> > +
> > +	if (vl > max_vl)
> > +		vl = max_vl;
> > +
> > +	bit = find_next_bit(sve_vq_map, SVE_VQ_MAX,
> > +			    vq_to_bit(sve_vq_from_vl(vl)));
> > +	return sve_vl_from_vq(bit_to_vq(bit));
> > +}
> > +
> 
> 
> Thanks,
> Alan.
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
