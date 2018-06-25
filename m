From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [PATCH v2 3/5] iommu/virtio: Add probe request
Date: Mon, 25 Jun 2018 18:52:38 +0100
Message-ID: <72f85cc1-f899-3575-1354-c3a4854cd47e@arm.com>
References: <20180621190655.56391-1-jean-philippe.brucker@arm.com>
	<20180621190655.56391-4-jean-philippe.brucker@arm.com>
	<20180622035442-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20180622035442-mutt-send-email-mst@kernel.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Mark Rutland <Mark.Rutland@arm.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "jayachandran.nair@cavium.com" <jayachandran.nair@cavium.com>, Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>, "tnowicki@caviumnetworks.com" <tnowicki@caviumnetworks.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>, "joro@8bytes.org" <joro@8bytes.org>, Will Deacon <Will.Deacon@arm.com>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "robh+dt@kernel.org" <robh+dt@kernel.org>, "eric.auger@redhat.com" <eric.auger@redhat.com>, Robin Murphy <Robin.Murphy@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 22/06/18 01:55, Michael S. Tsirkin wrote:
>> +#define VIRTIO_IOMMU_RESV_MEM_T_RESERVED	0
>> +#define VIRTIO_IOMMU_RESV_MEM_T_MSI		1
>> +
>> +struct virtio_iommu_probe_resv_mem {
>> +	__u8					subtype;
>> +	__u8					reserved[3];
>> +	__le64					start;
>> +	__le64					end;
>> +} __packed;
> 
> 
> start/end are not aligned you need to pad more.

The complete structure is actually the 32-bit header
virtio_iommu_probe_property, followed by the content
virtio_iommu_probe_resv_mem:

struct {
	le16	type
	le16	length
	u8	subtype
	u8	reserved[3]
	le64	start
	le64	end
};

I'll redefine virtio_iommu_probe_resv_mem to include this header.
Otherwise, without __packed, a compiler introduces padding when
concatenating header and content.

Thanks,
Jean
