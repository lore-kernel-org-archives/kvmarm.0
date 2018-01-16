From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Re: [RFC 1/4] arm64: Correct type for PUD macros
Date: Tue, 16 Jan 2018 11:39:30 +0000
Message-ID: <878tcyowwd.fsf@e105922-lin.cambridge.arm.com>
References: <20180110190729.18383-1-punit.agrawal@arm.com>
        <20180110190729.18383-2-punit.agrawal@arm.com>
        <20180116111740.tn6qy7yjs2d5ltx6@armageddon.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180116111740.tn6qy7yjs2d5ltx6@armageddon.cambridge.arm.com>
        (Catalin Marinas's message of "Tue, 16 Jan 2018 11:17:40 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, suzuki.poulose@arm.com, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Catalin Marinas <catalin.marinas@arm.com> writes:

> On Wed, Jan 10, 2018 at 07:07:26PM +0000, Punit Agrawal wrote:
>> The PUD macros (PUD_TABLE_BIT, PUD_TYPE_MASK, PUD_TYPE_SECT) use the
>> pgdval_t even when pudval_t is available. Even though the underlying
>> type for both (u64) is the same it is confusing and may lead to issues
>> in the future.
>> 
>> Fix this by using pudval_t to define the PUD_* macros.
>> 
>> Fixes: 084bd29810a56 ("ARM64: mm: HugeTLB support.")
>> Fixes: 206a2a73a62d3 ("arm64: mm: Create gigabyte kernel logical mappings where possible")
>> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>
> I queued this patch. I'll leave the KVM bits to Marc/Christoffer.

Thanks for picking up the fix.

Punit
