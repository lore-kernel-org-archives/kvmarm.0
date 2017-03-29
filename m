From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [kvmtool PATCH v9 09/15] arm: allow creation of an MSI register
 frame region
Date: Wed, 29 Mar 2017 09:37:56 +0100
Message-ID: <8f74de98-0418-615b-f852-893a9fa9c98c@arm.com>
References: <20170202163223.15372-1-andre.przywara@arm.com>
 <20170202163223.15372-10-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170202163223.15372-10-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: Vladimir Murzin <vladimir.murzin@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 02/02/17 16:32, Andre Przywara wrote:
> The GICv3 ITS expects a separate 64K page to hold ITS registers.
> Add a function to reserve such a page in the guest's I/O memory and
> use that for the ITS vGIC type.

Strictly speaking, this should be a 128kB region, including the page
containing GITS_TRANSLATER. Not that it matters much, but maybe we
should consider some special handling if the guest wanders too close to
the doorbell...

Thoughts?

	M.
-- 
Jazz is not dead. It just smells funny...
