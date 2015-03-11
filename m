From: Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Subject: Re: [PATCH v14 00/20] VFIO support for platform devices
Date: Wed, 11 Mar 2015 18:14:11 +0100
Message-ID: <CAN9JPjEu5qa=q_GaTWpb8Z48kvhwFVV3zkYiFsEFQsK2ZURmDg@mail.gmail.com>
References: <1425315600-29761-1-git-send-email-b.reynal@virtualopensystems.com>
	<CAN9JPjH0MQ-f2Vp-Cpd4GZfBtvVjWZKh_WDKrZz40AK14_Awrw@mail.gmail.com>
	<54FF2CEF.1050705@linaro.org>
	<1426010680.25026.77.camel@redhat.com>
	<54FFFF96.4010200@linaro.org>
	<CAN9JPjFpcu7NkgoCmMGZTw191g79mmtsbqzmj6z8s_bTMNKMPA@mail.gmail.com>
	<550064C9.9050408@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <550064C9.9050408-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: VirtualOpenSystems Technical Team <tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>, Linux IOMMU <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, kvm-arm <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

Ok, from what I've seen :

> - nit: interrupt.h not needed at early stage in vfio_platform_private.h,
> until irq introduction
This cannot be fixed by a follow-on patch as it is just the order in
the patch series.
> - version of the driver: 0.10?
Let's just keep it like that, moreover I didn't add any functionnality
since v10.

Which leaves only the wait.h in vfio_pci_intrs.c as an issue. Do we
really need a patch only to remove an include ? (And it seems that
this is already included by eventfd.h, so we don't need to move it to
vfio.h).

Finally everything seems ready for upstream, thanks everyone.

Best regards,
Baptiste

On Wed, Mar 11, 2015 at 4:52 PM, Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On 03/11/2015 11:08 AM, Baptiste Reynal wrote:
>> Thanks Eric and Alex for your reviews.
>>
>> I can confirm we can drop the dependency, as I re-tested without it.
>> Do you need a fix for the headers issue underlined by Eric ?
>
> Hi Baptiste,
>
> As far as I am concerned I do not have such request ;-)
>
> Best Regards
>
> Eric
>>
>> Best regards,
>> Baptiste
>>
>> On Wed, Mar 11, 2015 at 9:40 AM, Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>>> On 03/10/2015 07:04 PM, Alex Williamson wrote:
>>>> On Tue, 2015-03-10 at 18:42 +0100, Eric Auger wrote:
>>>>> Hi Baptiste,
>>>>>
>>>>> Please add:
>>>>> Reviewed-by: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> on the whole series
>>>>> Tested-by: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> on the whole series except
>>>>> AMBA specific patches.
>>>>>
>>>>> I currently exercise the following functionalities on Calxeda Midway HW:
>>>>> - MMIO read/write/mmap,
>>>>> - automasked IRQ + mask/unmask (NONE flag),
>>>>> - virqfd (unmask handler only).
>>>>>
>>>>> Despite a new thorough review I failed in pointing out any new
>>>>> interesting issues in this series.
>>>>>
>>>>> just minor points below:
>>>>>
>>>>> - PIO regions: currently read/write/mmap is not supported. I can't
>>>>> figure out how much this is a problem at this point?
>>>>
>>>> AIUI, nobody has any way to test this, which is why it's not
>>>> implemented.  I think we've done due diligence in accommodating PIO into
>>>> the vfio-platform framework though and hopefully it will be a simple
>>>> matter to add when someone has a use case for it.
>>>>
>>>>> - nit: vfio_pci_intrs.c: may not need wait.h anymore after removal of
>>>>> virqfd code. may be added in vfio.h
>>>>> - nit: interrupt.h not needed at early stage in vfio_platform_private.h,
>>>>> until irq introduction
>>>>> - version of the driver: 0.10?
>>>>
>>>> None of these seem like blockers, I'd be willing to accept header
>>>> cleanups as follow-on and driver versions are mostly arbitrary anyway.
>>>>
>>>>> Since there is no real dependency on "[PATCH v4 0/6] vfio: type1:
>>>>> support for ARM SMMUS with VFIO_IOMMU_TYPE1" I hope we can get this
>>>>> upstreamed soon.
>>>>
>>>> Me too, I also re-reviewed the series yesterday.  If Baptiste agrees
>>>> that there's no dependency on the other series, I can add your R-b/T-b,
>>>> do some additional testing, and queue the series for linux-next.
>>>> Thanks,
>>>
>>> Hi Alex,
>>>
>>> I let Baptiste answer. If he agrees please do as proposed. I am looking
>>> forward to seeing the series in linux-next!
>>>
>>> Best Regards
>>>
>>> Eric
>>>>
>>>> Alex
>>>>
>>>
>
