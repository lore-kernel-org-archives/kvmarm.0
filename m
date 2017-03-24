From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 25/28] ARM: decompressor: Remove __hyp_get_vectors usage
Date: Fri, 24 Mar 2017 15:26:15 +0000
Message-ID: <87vaqyr90o.fsf@on-the-bus.cambridge.arm.com>
References: <20170321192058.9300-1-marc.zyngier@arm.com>
 <20170321192058.9300-26-marc.zyngier@arm.com>
 <20170324143440.GE25903@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9546D40948
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Mar 2017 11:24:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WHae-ejhp94Z for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Mar 2017 11:24:28 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 478A5405DA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Mar 2017 11:24:27 -0400 (EDT)
In-Reply-To: <20170324143440.GE25903@cbox> (Christoffer Dall's message of
 "Fri, 24 Mar 2017 15:34:40 +0100")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, Keerthy <j-keerthy@ti.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 24 2017 at  2:34:40 pm GMT, Christoffer Dall <cdall@linaro.org> wrote:
> On Tue, Mar 21, 2017 at 07:20:55PM +0000, Marc Zyngier wrote:
>> When the compressed image needs to be relocated to avoid being
>> overwritten by the decompression process, we need to relocate
>> the hyp vectors as well so that we can find them once the
>> decompression has taken effect.
>> 
>> For that, we perform the following calculation:
>> 	u32 v = __hyp_get_vectors();
>> 	v += offset;
>> 	__hyp_set_vectors(v);
>> 
>> But we're guaranteed that the initial value of v as returned by
>> __hyp_get_vectors is always __hyp_stub_vectors, because we have
>> just set it by calling __hyp_stub_install.
>> 
>> So let's remove the use of __hyp_get_vectors, and directly use
>> __hyp_stub_vectors instead.
>> 
>> Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm/boot/compressed/head.S | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>> 
>> diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
>> index 9150f9732785..d58bb104c6e8 100644
>> --- a/arch/arm/boot/compressed/head.S
>> +++ b/arch/arm/boot/compressed/head.S
>> @@ -422,7 +422,10 @@ dtb_check_done:
>>  		cmp	r0, #HYP_MODE
>>  		bne	1f
>>  
>> -		bl	__hyp_get_vectors
>> +0:		adr	r0, 0b
>> +		movw	r1, #:lower16:__hyp_stub_vectors - 0b
>> +		movt	r1, #:upper16:__hyp_stub_vectors - 0b
>> +		add	r0, r0, r1
>
> nit: you could add a comment explaining what r0 ends up containing,
> because I'm pretty sure this will feel obscure when not read in the
> context of this series with your commit message above.

Sure. This is "Ard's magic stuff" - I'll document that.

Thanks,

	M.
-- 
Jazz is not dead, it just smell funny.
