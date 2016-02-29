From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH for-4.5] arm/kvm: fix ioctl error handling
Date: Mon, 29 Feb 2016 09:29:14 +0100
Message-ID: <20160229082914.GA3471@cbox>
References: <1456673397-23625-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1456673397-23625-1-git-send-email-mst@redhat.com>
Sender: stable-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Feb 28, 2016 at 05:32:07PM +0200, Michael S. Tsirkin wrote:
> Calling return copy_to_user(...) in an ioctl will not
> do the right thing if there's a pagefault:
> copy_to_user returns the number of bytes not copied
> in this case.
> 
> Fix up kvm to do
> 	return copy_to_user(...)) ?  -EFAULT : 0;
> 
> everywhere.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
