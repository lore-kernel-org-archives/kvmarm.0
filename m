From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] configure: honour $ARCH and $CROSS_COMPILE
Date: Mon, 21 Nov 2016 20:22:16 +0100
Message-ID: <20161121192215.GA12949@potion>
References: <20161121182250.13186-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161121182250.13186-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Andrew Jones <drjones@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org
List-Id: kvmarm@lists.cs.columbia.edu

2016-11-21 18:22+0000, Andre Przywara:
> Both environment variables seem to be standard in cross-compilation
> environments, especially with Linux.
> Let the configure script take those into account when setting the default
> values for --arch and --cross-prefix. Explicitly specifying the latter
> on the configure command line still works as expected.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Hi,
> 
> this maybe a personal itch to scratch here, since I set these two
> variables in my environment via a (sourced) script here and never have
> to care about the particular cross-compiler prefix, for instance.
> It looks rather generic, though, so I was wondering if this is useful
> upstream as well.

Definitely useful, thanks.

> diff --git a/configure b/configure
> @@ -8,8 +8,9 @@ objdump=objdump
>  ar=ar
>  addr2line=addr2line
>  arch=`uname -m | sed -e 's/i.86/i386/;s/arm.*/arm/;s/ppc64.*/ppc64/'`
> +[ -n "$ARCH" ] && arch="$ARCH"
>  host=$arch

Host should be set before we override arch, though.

I can swap those two lines when applying, but would prefer something
like:

  host=`uname -m | sed -e 's/i.86/i386/;s/arm.*/arm/;s/ppc64.*/ppc64/'`
  arch=${ARCH:-$host}

> -cross_prefix=
> +cross_prefix=${CROSS_COMPILE}
>  endian=""
>  pretty_print_stacks=yes

(And --help is not printing the default value for cross_prefix, which
 would be nice to change when we can have a non-empty one now.)
