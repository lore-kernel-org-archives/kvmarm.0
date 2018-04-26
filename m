From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v3 07/12] KVM: arm/arm64: Adapt vgic_v3_check_base to
 multiple rdist regions
Date: Thu, 26 Apr 2018 16:52:23 +0200
Message-ID: <920c2d0d-0f68-6336-1f8c-06a813eeac62@redhat.com>
References: <1523607658-9166-1-git-send-email-eric.auger@redhat.com>
 <1523607658-9166-8-git-send-email-eric.auger@redhat.com>
 <20180424210748.GH4533@C02W217FHV2R.local>
 <557b2aaf-3f6f-ea11-55e2-5667b651922b@redhat.com>
 <20180426100615.GB19872@C02W217FHV2R.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180426100615.GB19872@C02W217FHV2R.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@kernel.org, peter.maydell@linaro.org, andre.przywara@arm.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 04/26/2018 12:06 PM, Christoffer Dall wrote:
> On Thu, Apr 26, 2018 at 10:29:35AM +0200, Auger Eric wrote:
>> Hi Christoffer,
>> On 04/24/2018 11:07 PM, Christoffer Dall wrote:
>>> On Fri, Apr 13, 2018 at 10:20:53AM +0200, Eric Auger wrote:
>>>> We introduce a new helper to check there is no overlap between
>>>> dist region (if set) and registered rdist regions. This both
>>>> handles the case of legacy single rdist region (implicitly sized
>>>> with the number of online vcpus) and the new case of multiple
>>>> explicitly sized rdist regions.
>>>
>>> I don't understand this change, really.  Is this just a cleanup, or
>>> changing some functionality (why?).
>>>
>>> I think this could have come with the introduction of
>>> vgic_v3_rdist_overlap() before patch 6, and then patch 6 could have been
>>> simplified (hopefully) to just call this "check that nothing in the
>>> world ever collides withi itself" function.
>> I have merged this patch and vgic_v3_rd_region_size +
>> vgic_v3_rdist_overlap and put it before this patch.
>>
>> Also I reworked the commit message which was unclear I acknowledge.
>>
>> With respect to using the adapted  vgic_v3_check_base() in
>> vgic_v3_insert_redist_region(), it is less obvious to me.
>>
>> In vgic_v3_insert_redist_region we do the checks *before* inserting the
>> new rdist region in the list of redist regions. While
>> vgic_v3_check_base() does the checks on already registered rdist and
>> dist regions. So I would be tempted to leave
>> vgic_v3_insert_redist_region() implementation as it is.
>>
> 
> ok, but do see my suggestion there to factor out the check, which should
> make that function slightly easier to read.
> 
> Then perhaps you can use that function from vgic_v3_check_base to check
> that each rdist doesn't overlap with the distributor?

I introduced the suggested additional helper, vgic_dist_overlap, to
check a region does not overlap with the distributor region and used it
in vgic_v3_insert_redist_region.

However in  vgic_v3_check_base I do not need it as I already use
vgic_v3_rdist_overlap() which does the job, ie. check the dist against
all registered redists.

Thanks

Eric
> 
> Thanks,
> -Christoffer
> 
