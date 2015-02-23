From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: stand-alone kvmtool
Date: Mon, 23 Feb 2015 15:27:21 +0100
Message-ID: <20150223142721.GC5609@cbox>
References: <54DDD465.3050300@arm.com>
 <54E5C16D.3060109@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54E5C16D.3060109@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andre Przywara <andre.przywara@arm.com>, Pekka Enberg <penberg@kernel.org>, Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ronald Minnich <rminnich@google.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On Thu, Feb 19, 2015 at 05:56:45AM -0500, Sasha Levin wrote:

[...]

> 
> What inconvenience is caused by having it sit inside the kernel tree
> beyond an increased requirement in disk space?
> 
FWIW: I would prefer seeing this outside the kernel tree; I think it is
slightly confusing to keep it as part of a non-upstream kernel repo and
it is simpler to view git change logs etc. in gitweb for a stand-alone
repo.

-Christoffer
