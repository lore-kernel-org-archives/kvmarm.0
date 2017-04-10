From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 00/22] vITS save/restore
Date: Mon, 10 Apr 2017 13:54:49 +0100
Message-ID: <d730b3fd-f0be-58b6-02e9-3863682994cd@arm.com>
References: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

On 27/03/17 10:30, Eric Auger wrote:
> This series specifies and implements an API aimed at saving and restoring
> the state of the in-kernel emulated ITS device.
> 
> The ITS is programmed through registers and tables. Those latter
> are allocated by the guest. Their base address is programmed in
> registers or table entries before the ITS is enabled.
> 
> The ITS is free to use some of them to flush its internal caches. This
> is likely to be used when entering low power state.
> 
> Therefore, for save/restore use case, it looks natural to use this
> guest RAM allocated space to save the table related data. However,
> currently, The ITS in-kernel emulated device does not use all of those
> tables and for those it uses, it does not always sync them with its
> cached data. Additional sync must happen for:
> - the collection table
> - the device table
> - the per-device translation tables
> - the LPI pending tables.
> 
> The LPI configation table and the command queues do not need extra
> syncs.
> 
> An alternative to flushing the tables into guest RAM could have been
> to flush them into a separate user-space buffer. However the drawback
> of this alternative is that the virtualizer would allocate dedicated
> buffers to store the data that should normally be laid out in guest
> RAM. It would also be obliged to re-compute their size from
> register/table content.
> 
> So saving the tables in guest RAM better fit the ITS programming
> model and optimizes the memory usage. The drawback of this solution
> is it brings additional challenges at user-space level to make sure
> the guest RAM is frozen after table sync.

I think this series is on the right track. What it needs is some
clarification in the spec (as outlined by Christoffer), some tidying up
around the encoding, and various nits that need addressing all over the map.

The only architectural issue is really the ITS/GICR split, but I don't
think this is a big deal.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
